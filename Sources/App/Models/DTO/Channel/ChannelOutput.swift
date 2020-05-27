import Vapor

extension Channel {
    struct _Output: Content {
        var id: String
        var imageString: String
        var title: String
        var subChannel: [SubChannel]
        
        init(id: String, imageString: String, title: String, subChannel: [SubChannel]) {
            self.id = id
            self.imageString = imageString
            self.title = title
            self.subChannel = subChannel
        }
        
        init(from channel: Channel) {
            self.init(id: channel.id!.uuidString, imageString: channel.imageString, title: channel.title, subChannel: channel.subChannel)
        }
    }
}
