import Vapor

//Write a Validation for Category before using to Content for decoding

extension User.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: !.empty)
        validations.add("profile_photo_string", as: String.self, is: !.empty)
    }
}

