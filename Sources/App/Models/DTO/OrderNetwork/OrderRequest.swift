import Vapor

//Write a Validation for Category before using to Content for decoding

extension Order.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("product_name", as: String.self, is: !.empty)
        validations.add("image_string", as: String.self, is: !.empty)
         validations.add("currency", as: String.self, is: !.empty)
    }
}
