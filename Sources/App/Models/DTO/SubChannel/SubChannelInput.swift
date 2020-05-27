import Vapor

extension SubChannel {
    struct _Input: Content {
        var imageString: String
        var title: String
        var channelID: Channel.IDValue
        var userID: User.IDValue
        
        init(imageString: String, title: String, channelID: Channel.IDValue, userID: User.IDValue) {
            self.imageString = imageString
            self.title = title
            self.channelID = channelID
            self.userID = userID
        }
        
        init(from subChannel: SubChannel) {
            self.init(imageString: subChannel.imageString, title: subChannel.title, channelID: subChannel.$channel.id, userID: subChannel.$user.id)
        }
    }
}

