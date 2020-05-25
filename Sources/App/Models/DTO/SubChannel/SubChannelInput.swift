import Vapor

extension SubChannel {
    struct _Input: Content {
        var imageString: String
        var title: String
        
        init(imageString: String, title: String) {
            self.imageString = imageString
            self.title = title
        }
        
        init(from subChannel: SubChannel) {
            self.init(imageString: subChannel.imageString, title: subChannel.title)
        }
    }
}

