import Vapor
import Fluent

struct AuthenticationController {
    
    //Register User
    func register(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try RegisterRequest.validate(req)
        let registerRequest = try req.content.decode(RegisterRequest.self)
        guard registerRequest.password == registerRequest.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        return req.password
            .async
            .hash(registerRequest.password)
            .flatMapThrowing{ try User(from: registerRequest, hash: $0) }
            .flatMap { user in
                req.users
                    .create(user)
                    .flatMapErrorThrowing {
                        if let dbError = $0 as? DatabaseError,
                            dbError.isConstraintFailure {
                            throw AuthenticationError.emailAlreadyExists
                        }
                        throw $0
                }
                //                .flatMap { req.emailVerifier.verify(for: user) }
        }
        .transform(to: .created)
    }
    
    //Login User
    func login(_ req: Request) throws -> EventLoopFuture<LoginResponse> {
        try LoginRequest.validate(req)
        let loginRequest = try req.content.decode(LoginRequest.self)
        return req.users
            .find(email: loginRequest.email)
            .unwrap(or: AuthenticationError.invalidEmailOrPassword)
            .guard({ $0.isEmailVerified }, else: AuthenticationError.emailIsNotVerified)
            .flatMap { user -> EventLoopFuture<User> in
                return req.password
                    .async
                    .verify(loginRequest.password, created: user.passwordHash)
                    .guard({ $0 == true }, else: AuthenticationError.invalidEmailOrPassword)
                    .transform(to: user)
        }
        .flatMap { user -> EventLoopFuture<User> in
            do {
                return try req.refreshTokens.delete(for: user.requireID()).transform(to: user)
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
        .flatMap { user in
            do {
                let token = req.random.generate(bits: 256)
                let refreshToken = try RefreshToken(token: SHA256.hash(token), userID: user.requireID())
                
                return req.refreshTokens
                    .create(refreshToken)
                    .flatMapThrowing {
                        try LoginResponse(
                            user: User.Output(from: user),
                            accessToken: req.jwt.sign(Payload(with: user)),
                            refreshToken: token
                        )
                }
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }
    
    func refreshAccessToken(_ req: Request) throws -> EventLoopFuture<AccessTokenResponse> {
        let accessTokenRequest = try req.content.decode(AccessTokenRequest.self)
        let hashedRefreshToken = SHA256.hash(accessTokenRequest.refeshToken)
        
        return req.refreshTokens
            .find(token: hashedRefreshToken)
            .unwrap(or: AuthenticationError.refreshTokenOrUserNotFound)
            .flatMap { req.refreshTokens.delete($0).transform(to: $0) }
            .guard({ $0.expiresAt > Date() }, else: AuthenticationError.refreshTokenHasExpired)
            .flatMap { req.users.find(id: $0.$user.id) }
            .unwrap(or: AuthenticationError.refreshTokenOrUserNotFound)
            .flatMap { user in
                do {
                    let token = req.random.generate(bits: 256)
                    let refreshToken = try RefreshToken(token: SHA256.hash(token), userID: user.requireID())
                    
                    let payload = try Payload(with: user)
                    let accessToken = try req.jwt.sign(payload)
                    
                    return req.refreshTokens
                        .create(refreshToken)
                        .transform(to: (token, accessToken))
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
        }
        .map { AccessTokenResponse(refreshToken: $0, accessToken: $1) }
    }
    
    func verifyEmail(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let token = try req.query.get(String.self, at: Constants.shared.TOKEN)
        let hashedToken = SHA256.hash(token)
        
        return req.emailTokens
            .find(token: hashedToken)
            .unwrap(or: AuthenticationError.emailTokenNotFound)
            .flatMap { req.emailTokens.delete($0).transform(to: $0) }
            .guard({ $0.expiresAt > Date() },
                   else: AuthenticationError.emailTokenHasExpired)
            .flatMap {
                req.users.set(\.$isEmailVerified, to: true, for: $0.$user.id)
        }
        .transform(to: .ok)
    }
    
    func resetPassword(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let resetPasswordRequest = try req.content.decode(ResetPasswordRequest.self)
        
        return req.users
            .find(email: resetPasswordRequest.email)
            .flatMap {
                if let user = $0 {
                    return req.passwordResetter
                        .reset(for: user)
                        .transform(to: .noContent)
                } else {
                    return req.eventLoop.makeSucceededFuture(.noContent)
                }
        }
    }
    
    func verifyResetPasswordToken(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let token = try req.query.get(String.self, at: Constants.shared.TOKEN)
        
        let hashedToken = SHA256.hash(token)
        
        return req.passwordTokens
            .find(token: hashedToken)
            .unwrap(or: AuthenticationError.invalidPasswordToken)
            .flatMap { passwordToken in
                guard passwordToken.expiresAt > Date() else {
                    return req.passwordTokens
                        .delete(passwordToken)
                        .transform(to: req.eventLoop
                            .makeFailedFuture(AuthenticationError.passwordTokenHasExpired)
                    )
                }
                
                return req.eventLoop.makeSucceededFuture(.noContent)
        }
    }
    
    func recoverAccount(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try RecoverAccountRequest.validate(req)
        let content = try req.content.decode(RecoverAccountRequest.self)
        
        guard content.password == content.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        
        let hashedToken = SHA256.hash(content.token)
        
        return req.passwordTokens
            .find(token: hashedToken)
            .unwrap(or: AuthenticationError.invalidPasswordToken)
            .flatMap { passwordToken -> EventLoopFuture<Void> in
                guard passwordToken.expiresAt > Date() else {
                    return req.passwordTokens
                        .delete(passwordToken)
                        .transform(to: req.eventLoop
                            .makeFailedFuture(AuthenticationError.passwordTokenHasExpired)
                    )
                }
                
                return req.password
                    .async
                    .hash(content.password)
                    .flatMap { digest in
                        req.users.set(\.$passwordHash, to: digest, for: passwordToken.$user.id)
                }
                .flatMap { req.passwordTokens.delete(for: passwordToken.$user.id) }
        }
        .transform(to: .noContent)
    }
    
    func sendEmailVerification(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let content = try req.content.decode(SendEmailVerificationRequest.self)
        
        return req.users
            .find(email: content.email)
            .flatMap {
                guard let user = $0, !user.isEmailVerified else {
                    return req.eventLoop.makeSucceededFuture(.noContent)
                }
                
                return req.emailVerifier
                    .verify(for: user)
                    .transform(to: .noContent)
        }
    }
    
    ////MARK: RUD Methods
    func getCurrentUser(_ req: Request) throws -> EventLoopFuture<User.Output> {
        let payload = try req.auth.require(Payload.self)
        return req.users
            .find(id: payload.userID)
            .unwrap(or: Abort(.notFound))
            .map { User.Output(from: $0) }
    }
    
    func fetchEagerAllUsers(_ req: Request) throws -> EventLoopFuture<[User.Output]> {
        return req.users
            .all()
            .map{ $0.map { User.Output(from: $0) } }
    }
    
    func fetchUser(_ req: Request) throws -> EventLoopFuture<User.Output> {
        guard let id = req.parameters.get(Constants.shared.USER_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.users
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map { User.Output(from: $0) }
    }
    
    func deleteCurrentUser(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.auth.require(Payload.self)
        guard let id = req.parameters.get(Constants.shared.USER_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        if payload.userID == id {
            return req.users
                .delete(id: payload.userID)
                .transform(to: .ok)
        } else {
            throw {Abort(.badRequest)}()
        }
    }
    
    func deleteUser(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.auth.require(Payload.self)
        if payload.isAdmin {
            guard let id = req.parameters.get(Constants.shared.USER_ID_STRING, as: UUID.self) else {
                throw Abort(.badRequest)
            }
            return req.users
                .delete(id: id)
                .transform(to: .ok)
        } else {
            return req.users
                .find(id: payload.userID)
                .transform(to: .unauthorized)
        }
    }
    
    func editUser(_ request: Request) throws -> EventLoopFuture<User.Input> {
        guard let id = request.parameters.get(Constants.shared.USER_ID_STRING, as: UUID.self) else { throw Abort(.badRequest) }
        let user = try request.content.decode(User.Input.self)
        let foundUser = User.find(id, on: request.db)
        return foundUser
            .unwrap(or: Abort(.notFound))
            .flatMap { updateUser in
                updateUser.username = user.username
                updateUser.email = user.email.lowercased()
                updateUser.profilePhotoString = user.profilePhotoString
                updateUser.isAdmin = user.isAdmin
                return updateUser.save(on: request.db)
                    .map { User.Input(username: user.username, email: user.email.lowercased(), profilePhotoString: user.profilePhotoString, isAdmin: user.isAdmin, isEmailVerified: true)
                }
        }
    }
    func editCurrentUser(_ request: Request) throws -> EventLoopFuture<User.Input> {
        guard let id = request.parameters.get(Constants.shared.USER_ID_STRING, as: UUID.self) else { throw Abort(.badRequest) }
        let user = try request.content.decode(User.Input.self)
        let foundUser = User.find(id, on: request.db)
        return foundUser
            .unwrap(or: Abort(.notFound))
            .flatMap { updateUser in
                updateUser.username = user.username
                updateUser.email = user.email.lowercased()
                updateUser.profilePhotoString = user.profilePhotoString
                return updateUser.save(on: request.db)
                    .map { User.Input(username: user.username, email: user.email.lowercased(), profilePhotoString: user.profilePhotoString, isAdmin: user.isAdmin, isEmailVerified: true)
                }
        }
    }
}
