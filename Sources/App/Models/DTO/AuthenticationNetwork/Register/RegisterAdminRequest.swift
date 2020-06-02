
import Vapor
import Fluent

struct RegisterAdminRequest: Content {
    let username: String
    let email: String
    let password: String
    let confirmPassword: String
    let isAdmin: Bool
    let isEmailVerified: Bool
}

extension RegisterAdminRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: .count(3...))
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("isAdmin", as: Bool.self, is: .valid)
        validations.add("isEmailVerified", as: Bool.self, is: .valid)
    }
}

extension User {
    convenience init(from register: RegisterAdminRequest, hash: String) throws {
        self.init(username: register.username, email: register.email.lowercased(), passwordHash: hash, isAdmin: register.isAdmin, isEmailVerified: register.isEmailVerified)
    }
    
}
