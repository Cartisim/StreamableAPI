import Vapor
import Fluent

final class SubChannel: Codable, Model, Authenticatable, Content {

    typealias Input = _Input
    typealias Output = _Output
    
    static let schema = "sub_channel"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "image_string")
    var imageString: String
    
    @Field(key: "title")
    var title: String

    @Parent(key: "channel")
    var channel: Channel
    
    @Parent(key: "user")
    var user: User
    
    @Children(for: \.$subChannel)
    var message: [Message]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deletted_at", on: .delete)
    var deletedAt: Date?
    
       init() {}
    
    init(id: UUID?, imageString: String, title: String, channelID: Channel.IDValue, userID: User.IDValue) {
        self.id = id
        self.imageString = imageString
        self.title = title
        self.channel.id = channelID
        self.user.id = userID
    }
    
}


