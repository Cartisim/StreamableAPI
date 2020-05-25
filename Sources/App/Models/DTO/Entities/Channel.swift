import Vapor
import Fluent

final class Channel: Codable, Model, Authenticatable, Content {

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
    var subChannelID: [SubChannel]

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
       init() {}
    
    init(id: UUID? = nil, imageString: String, title: String) {
        self.id = id
        self.imageString = imageString
        self.title = title
    }
}


