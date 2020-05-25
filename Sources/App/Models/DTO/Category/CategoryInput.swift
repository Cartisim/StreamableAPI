import Vapor

extension Category {
    struct _Input: Content {
        var categoryName: String
        
        init(categoryName: String) {
            self.categoryName = categoryName
        }
        
        init(from categrory: Category) {
            self.init(categoryName: categrory.categoryName)
        }
    }
}
