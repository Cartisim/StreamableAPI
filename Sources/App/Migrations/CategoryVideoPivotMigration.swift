import Vapor
import Fluent

struct CreateCategoryVideoPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("category_video")
        .id()
            .field("category_id", .uuid, .required, .references("category", "id", onDelete: .cascade, onUpdate: .noAction))
            .field("video_id", .uuid, .required, .references("video", "id", onDelete: .cascade, onUpdate: .noAction))
        .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("category_video").delete()
    }
    
    var name: String {"CreateCategoryVideoPivot"}
}
