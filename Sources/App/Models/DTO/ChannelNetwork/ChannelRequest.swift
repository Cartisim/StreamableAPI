import Vapor

//Write a Validation for Category before using to Content for decoding

extension Channel.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("imageString", as: String.self, is: !.empty)
        validations.add("title", as: String.self, is: !.empty)
        
    }
}

extension Channel {
    convenience init(from channel: Channel.Input) throws {
        self.init(imageString: channel.imageString, title: channel.title)
    }
}
