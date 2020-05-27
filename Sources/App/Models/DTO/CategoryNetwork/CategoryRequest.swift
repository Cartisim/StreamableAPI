import Vapor

//Write a Validation for Category before using to Content for decoding

extension Category.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("categoryName", as: String.self, is: !.empty)
    }
}

extension Category {
    convenience init(from category: Category.Input) throws {
        self.init(categoryName: category.categoryName)
    }
}

