import Vapor
import Fluent

/*Migrations prepare the Database for the Model, we need this because PSQL's schema is pre-defined, we can also seed the DB */

extension Channel {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("channel")
                .id()
                .field("title", .string, .required)
                .field("image_string", .string, .required)
                 .field("created_at", .datetime, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("channel").delete()
        }
        
        var name: String {"CreateChannel"}
    }
}

