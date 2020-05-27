import Vapor
import Fluent

final class Channel: Codable, Model  {

    typealias Input = _Input
    typealias Output = _Output
    
    static let schema = "channel"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "image_string")
    var imageString: String
    
    @Field(key: "title")
    var title: String
    
    @Children(for: \.$channel)
    var subChannel: [SubChannel]

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
       init() {}
    
    init(id: UUID? = nil, imageString: String, title: String) {
        self.id = id
        self.imageString = imageString
        self.title = title
    }
}


