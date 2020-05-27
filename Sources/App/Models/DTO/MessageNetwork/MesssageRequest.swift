import Vapor

//Write a Validation for Category before using to Content for decoding

extension Message.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("profilePhotoString", as: String.self, is: !.empty)
        validations.add("username", as: String.self, is: !.empty)
        validations.add("message", as: String.self, is: !.empty)
    }
}

extension Message {
    convenience init(from message: Message.Input) throws {
        self.init(profilePhotoString: message.profilePhotoString, username: message.username, message: message.message, subChannelID: message.subChannelID, userID: message.userID)
    }
}
