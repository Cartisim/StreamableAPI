import Vapor

extension SubChannel {
    struct _Output: Content {
        var id: String
        var imageString: String
        var title: String
        var message: [Message]
        
        init(id: String, imageString: String, title: String, message: [Message]) {
            self.id = id
            self.imageString = imageString
            self.title = title
            self.message = message
        }
        
        init(from subChannel: SubChannel) {
            self.init(id: subChannel.id!.uuidString, imageString: subChannel.imageString, title: subChannel.title, message: subChannel.message)
        }
    }
}

