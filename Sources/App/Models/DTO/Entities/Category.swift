import Vapor
import Fluent

final class Category: Codable, Model, Content {
    typealias Input = _Input

    typealias Output = _Output
    
    static let schema = "category"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "category_name")
    var categoryName: String
    
    @Siblings(through: VideoCategoryPivot.self, from: \.$category, to: \.$video)
         var video: [Video]
    
    init() {}
    
    init(id: UUID?, categoryName: String) {
        self.id = id
        self.categoryName = categoryName
    }
    
    
    init(_ input: Input) throws {
        self.categoryName = input.categoryName
    }
    
    func update(_ input: Input) throws {
        self.categoryName = input.categoryName
    }
    
    var output: Output {
        .init(id: self.id!.uuidString, categoryName: self.categoryName, video: self.video)
    }
}

