import Vapor

extension Channel {
    struct _Input: Content {
        var imageString: String
        var title: String
        
        init(imageString: String, title: String) {
            self.imageString = imageString
            self.title = title
        }
        
        init(from channel: Channel) {
            self.init(imageString: channel.imageString, title: channel.title)
        }
    }
}
