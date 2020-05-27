import Vapor
import Fluent

final class Category: Codable, Model {
    
    typealias Input = _Input
    typealias Output = _Output
    
    static let schema = "category"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "category_name")
    var categoryName: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Siblings(through: CategoryVideoPivot.self, from: \.$category, to: \.$video)
         var video: [Video]
    
    init() {}
    
    init(id: UUID? = nil, categoryName: String) {
        self.id = id
        self.categoryName = categoryName
    }
}

