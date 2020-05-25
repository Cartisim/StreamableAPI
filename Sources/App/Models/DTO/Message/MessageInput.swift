import Vapor

extension Message {
    struct _Input: Content {
        var profilePhotoString: String
        var username: String
        var message: String
        var subChannelID: SubChannel.IDValue
        var userID: User.IDValue
        
        init(profilePhotoString: String, username: String, message: String, subChannelID: SubChannel.IDValue, userID: User.IDValue) {
            self.profilePhotoString = profilePhotoString
            self.username = username
            self.message = message
            self.subChannelID = subChannelID
            self.userID = userID
        }
        
        init(from message: Message) {
            self.init(profilePhotoString: message.profilePhotoString, username: message.username, message: message.message, subChannelID: message.$subChannel.id, userID: message.$user.id)
        }
    }
}
