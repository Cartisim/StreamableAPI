import Vapor
import Fluent

final class SubChannel: Codable, Model {

    typealias Input = _Input
    typealias Output = _Output
    
    static let schema = "sub_channel"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "image_string")
    var imageString: String
    
    @Field(key: "title")
    var title: String

    @Parent(key: "channel_id")
    var channel: Channel
    
    @Parent(key: "user_id")
    var user: User
    
    @Children(for: \.$subChannel)
    var message: [Message]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
       init() {}
    
    init(id: UUID? = nil, imageString: String, title: String, channelID: Channel.IDValue, userID: User.IDValue) {
        self.id = id
        self.imageString = imageString
        self.title = title
        self.$channel.id = channelID
        self.$user.id = userID
    }
    
}


