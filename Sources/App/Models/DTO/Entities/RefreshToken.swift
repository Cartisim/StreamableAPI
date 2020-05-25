import Vapor
import Fluent

final class RefreshToken: Model {
    static let schema = "user_refresh_token"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "token")
    var token: String
    
    @Field(key: "expires_at")
    var expiresAt: Date
    
    @Field(key: "issued_at")
    var issuedAt: Date
    
    @Parent(key: "user_id")
    var user: User
    
    init() {}
    
    init(id: UUID?, token: String, userID: UUID, expiresAt: Date = Date().addingTimeInterval(Constants.shared.REFRESH_TOKEN_LIFETIME), issuedAt: Date = Date()) {
        self.id = id
        self.token = token
        self.$user.id = userID
        self.expiresAt = expiresAt
        self.issuedAt = issuedAt
    }
}
