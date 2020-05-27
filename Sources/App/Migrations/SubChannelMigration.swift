import Vapor
import Fluent

/*Migrations prepare the Database for the Model, we need this because PSQL's schema is pre-defined, we can also seed the DB */

extension SubChannel {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("sub_channel")
                .id()
                .field("title", .string, .required)
                .field("image_string", .string, .required)
                .field("channel_id", .uuid, .required, .references("channel", "id", onDelete: .cascade, onUpdate: .noAction))
                 .field("created_at", .datetime, .required)
                .field("user_id", .uuid, .required, .references("user", "id", onDelete: .cascade, onUpdate: .noAction))
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("sub_channel").delete()
        }
        
        var name: String {"CreateSubChannel"}
    }
}
