import Vapor
import JWT

struct Payload: JWTPayload, Authenticatable {
    var userID: UUID
    var username: String
    var email: String
    var isAdmin: Bool
    
    var exp: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
    
    init(with user: User) throws {
        self.userID = try user.requireID()
        self.username = user.username
        self.email = user.email
        self.isAdmin = user.isAdmin
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(Constants.shared.ACCESS_TOKEN_LIFETIME))
    }
    
}
