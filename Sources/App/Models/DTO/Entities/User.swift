import Vapor
import Fluent

final class User: Codable, Model, Authenticatable, Content {
    
    typealias Input = _Input
    typealias Output = _Output
    
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "profile_photo_string")
    var profilePhotoString: String
    
    @Field(key: "is_admin")
    var isAdmin: Bool
    
    @Field(key: "is_email_verified")
    var isEmailVerified: Bool
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Children(for: \.$user)
    var order: [Order]
    
    @Children(for: \.$user)
    var message: [Message]
    
    init() {}
    
    init(id: UUID? = nil, username: String, email: String, passwordHash: String, profilePhotoString: String = "", isAdmin: Bool = false, isEmailVerified: Bool = true) {
        self.id = id
        self.username = username
        self.email = email
        self.passwordHash = passwordHash
        self.profilePhotoString = profilePhotoString
        self.isAdmin = isAdmin
        self.isEmailVerified = isEmailVerified
    }
    
    
}
