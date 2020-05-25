import Vapor

//Write a Validation for Category before using to Content for decoding

extension Video.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("poster_string", as: String.self, is: !.empty)
        validations.add("video_string", as: String.self, is: !.empty)
        validations.add("rating", as: String.self, is: !.empty)
        validations.add("time", as: String.self, is: !.empty)
        validations.add("description", as: String.self, is: !.empty)
    }
}
