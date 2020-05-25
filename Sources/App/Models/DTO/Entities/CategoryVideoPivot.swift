import Vapor
import Fluent

final class CategoryVideoPivot: Model {
    static let schema: String = "category_video"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "category_id")
    var category: Category
    
    @Parent(key: "video_id")
    var video: Video
    
    init() {}
    
    init(categoryID: UUID, videoID: UUID) {
        self.category.id = categoryID
        self.video.id = videoID
    }
}


