
import Vapor
import Fluent

struct CreateOrderVideoPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("order_video")
            .id()
            .field("order_id", .uuid, .required, .references("order", "id", onDelete: .cascade, onUpdate: .noAction))
            .field("video_id", .uuid, .required, .references("video", "id", onDelete: .cascade, onUpdate: .noAction))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("order_video").delete()
    }
    
    var name: String { "CreateOrderVideoPivot" }
}
