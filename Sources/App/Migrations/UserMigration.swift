import Fluent

extension User {
    struct Migration: Fluent.Migration {
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user")
                .id()
                .field("username", .string, .required)
                .field("email", .string, .required)
                .field("password_hash", .string, .required)
                .field("profile_photo_string", .string, .required)
                .field("is_admin", .bool, .required, .custom("DEFAULT FALSE"))
                .field("is_email_verified", .bool, .required, .custom("DEFAULT FALSE"))
                .unique(on: "email")
                .create()
        }
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user").delete()
        }
        
        var name: String { "CreateUser" }
    }
}
