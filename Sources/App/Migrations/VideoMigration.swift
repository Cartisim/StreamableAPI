import Vapor
import Fluent

/*Migrations prepare the Database for the Model, we need this because PSQL's schema is pre-defined, we can also seed the DB */

extension Video {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("video")
                .id()
                .field("title", .string, .required)
                .field("poster_string", .string, .required)
                .field("video_string", .string, .required)
                 .field("rating", .string, .required)
                 .field("time", .string, .required)
                 .field("description", .string, .required)
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("video").delete()
        }
        
        var name: String {"CreateVideor"}
    }
}
