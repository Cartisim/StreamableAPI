import Vapor

extension Channel {
    struct _Output: Content {
        var id: String
        var imageString: String
        var title: String
        
        init(id: String, imageString: String, title: String) {
            self.id = id
            self.imageString = imageString
            self.title = title
        }
        
        init(from channel: Channel) {
            self.init(id: channel.id!.uuidString, imageString: channel.imageString, title: channel.title)
        }
    }
}
