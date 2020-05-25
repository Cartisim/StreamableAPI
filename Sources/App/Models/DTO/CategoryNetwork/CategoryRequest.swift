import Vapor

//Write a Validation for Category before using to Content for decoding

extension Category.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("category_name", as: String.self, is: !.empty)
    }
}
