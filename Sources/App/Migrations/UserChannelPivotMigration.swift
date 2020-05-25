
import Vapor
import Fluent

struct CreateUserChannelPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user_channel")
            .id()
            .field("user_id", .uuid, .required, .references("user", "id", onDelete: .cascade, onUpdate: .noAction))
            .field("channel_id", .uuid, .required, .references("channel", "id", onDelete: .cascade, onUpdate: .noAction))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user_channel").delete()
    }
    
    var name: String { "CreateUserChannelPivot" }
}

