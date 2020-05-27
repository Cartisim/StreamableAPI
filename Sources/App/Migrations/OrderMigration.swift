import Vapor
import Fluent

/*Migrations prepare the Database for the Model, we need this because PSQL's schema is pre-defined, we can also seed the DB */

extension Order {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("order")
                .id()
                .field("product_name", .string, .required)
                .field("image_string", .string, .required)
                .field("currency", .string, .required)
                 .field("quantity", .int, .required)
                 .field("price", .int, .required)
                 .field("is_purchased", .bool, .required)
                 .field("videoid", .string, .required)
                 .field("created_at", .datetime, .required)
                .field("user_id", .uuid, .required, .references("user", "id", onDelete: .cascade, onUpdate: .noAction))
                .create()
        }
        
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("order").delete()
        }
        
        var name: String {"CreateOrder"}
    }
}
