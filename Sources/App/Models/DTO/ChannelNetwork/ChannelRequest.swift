import Vapor

//Write a Validation for Category before using to Content for decoding

extension Channel.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("image_string", as: String.self, is: !.empty)
        validations.add("title", as: String.self, is: !.empty)
        
    }
}
