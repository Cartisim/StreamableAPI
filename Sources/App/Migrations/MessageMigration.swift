import Vapor
import Fluent

/*Migrations prepare the Database for the Model, we need this because PSQL's schema is pre-defined, we can also seed the DB */

extension Message {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("message")
                .id()
                .field("profile_photo_string", .string, .required)
                .field("username", .string, .required)
                .field("message", .string, .required)
                .field("sub_channel_id", .uuid, .required, .references("sub_channel", "id", onDelete: .cascade, onUpdate: .noAction))
                 .field("created_at", .datetime, .required)
                .field("user_id", .uuid, .references("user", "id", onDelete: .cascade, onUpdate: .noAction))
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("message").delete()
        }
        
        var name: String {"CreateMessage"}
    }
}
