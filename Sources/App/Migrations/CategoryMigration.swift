import Vapor
import Fluent

/*Migrations prepare the Database for the Model, we need this because PSQL's schema is pre-defined, we can also seed the DB */

extension Category {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("category")
            .id()
                .field("category_name", .string, .required)
                 .field("created_at", .datetime, .required)
            .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("category").delete()
        }
        
        var name: String {"CreateCategory"}
    }
}
