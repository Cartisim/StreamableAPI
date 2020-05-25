import Vapor

extension SubChannel {
    struct _Output: Content {
        var id: String
        var imageString: String
        var title: String
        
        init(id: String, imageString: String, title: String) {
            self.id = id
            self.imageString = imageString
            self.title = title
        }
        
        init(from subChannel: SubChannel) {
            self.init(id: subChannel.id!.uuidString, imageString: subChannel.imageString, title: subChannel.title)
        }
    }
}

