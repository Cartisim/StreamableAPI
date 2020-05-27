import Vapor
import Fluent

final class Video: Model, Content {
    
    typealias Input = _Input
    
    typealias Output = _Output
    
    
    static let schema = "video"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "poster_string")
    var posterString: String
    
    @Field(key: "video_string")
    var videoString: String
    
    @Field(key: "rating")
    var rating: String
    
    @Field(key: "time")
    var time: String
    
    @Field(key: "description")
    var description: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Siblings(through: OrderVideoPivot.self, from: \.$video, to: \.$order)
    var order: [Order]
    
    @Siblings(through: CategoryVideoPivot.self, from: \.$video, to: \.$category)
    var category: [Category]
    
    init() {}
    
    init(id: UUID? = nil, title: String, posterString: String, videoString: String, rating: String, time: String, description: String) {
        self.title = title
        self.posterString = posterString
        self.videoString = videoString
        self.rating = rating
        self.time = time
        self.description = description
    }
    
//    init(_ input: _Input) throws {
//        self.title = input.title
//        self.posterString = input.posterString
//        self.videoString = input.videoString
//        self.rating = input.rating
//        self.time = input.time
//        self.description = input.description
//    }
//
//    func update(_ input: _Input) throws {
//        self.title = input.title
//        self.posterString = input.posterString
//        self.videoString = input.videoString
//        self.rating = input.rating
//        self.time = input.time
//        self.description = input.description
//    }
//
//    var output: _Output {
//        init(id: self.id!.uuidString, title: self.title, posterString: self.posterString, videoString: self.videoString, rating: self.rating, time: self.time, description: self.description)
//    }
}


