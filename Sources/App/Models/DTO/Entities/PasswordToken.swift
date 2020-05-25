import Vapor
import Fluent

final class PasswordToken: Model {
    static var schema = "user_password_token"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "token")
    var token: String
    
    @Field(key: "expires_at")
    var expiresAt: Date
    
    @Parent(key: "user_id")
    var user: User
    
    init() {}
    
    init(id: UUID? = nil, userID: UUID, token: String, expiresAt: Date = Date().addingTimeInterval(Constants.shared.RESET_PASSWORD_TOKEN_LIFETIME)) {
        self.id = id
        self.$user.id = userID
        self.token = token
        self.expiresAt = expiresAt
    }
}
