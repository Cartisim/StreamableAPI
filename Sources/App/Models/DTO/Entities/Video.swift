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
    
    @Field(key: "price")
    var price: Int
    
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
    
    @Field(key: "genre")
    var genre: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Siblings(through: OrderVideoPivot.self, from: \.$video, to: \.$order)
    var order: [Order]
    
    @Siblings(through: CategoryVideoPivot.self, from: \.$video, to: \.$category)
    var category: [Category]
    
    init() {}
    
    init(id: UUID? = nil, title: String, price: Int, posterString: String, videoString: String, rating: String, time: String, description: String, genre: String) {
        self.title = title
        self.price = price
        self.posterString = posterString
        self.videoString = videoString
        self.rating = rating
        self.time = time
        self.description = description
        self.genre = genre
    }
}


