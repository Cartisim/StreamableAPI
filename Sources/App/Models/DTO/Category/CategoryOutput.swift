import Vapor

extension Category {
    struct _Output: Content {
        var id: String
        var categoryName: String
        var video: [Video]
        
        init(id: String, categoryName: String, video: [Video]) {
            self.id = id
            self.categoryName = categoryName
            self.video = video
        }
        
        init(from category: Category) {
            self.init(id: category.id!.uuidString, categoryName: category.categoryName, video: category.video)
        }
    }
}
