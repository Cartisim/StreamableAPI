import Vapor

//Write a Validation for Category before using to Content for decoding

extension SubChannel.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("imageString", as: String.self, is: !.empty)
        validations.add("title", as: String.self, is: !.empty)
        
    }
}

extension SubChannel {
    convenience init(from subChannel: SubChannel.Input) throws {
        self.init(imageString: subChannel.imageString, title: subChannel.title, channelID: subChannel.channelID, userID: subChannel.userID)
    }
}
