import Vapor
import Fluent

final class VideoCategoryPivot: Model {
    static let schema: String = "course_category"
    
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


