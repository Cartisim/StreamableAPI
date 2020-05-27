import Vapor
import Fluent

final class Message: Codable, Model {
    
    typealias Input = _Input
    typealias Output = _Output
    
    static let schema = "message"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "profile_photo_string")
    var profilePhotoString: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "message")
    var message: String
    
    @Parent(key: "sub_channel_id")
    var subChannel: SubChannel
    
    @Parent(key: "user_id")
    var user: User
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
       init() {}
    
    init(id: UUID? = nil, profilePhotoString: String, username: String, message: String, subChannelID: SubChannel.IDValue, userID: User.IDValue) {
        self.id = id
        self.profilePhotoString = profilePhotoString
        self.username = username
        self.message = message
        self.$subChannel.id = subChannelID
        self.$user.id = userID
        
    }
    
}

