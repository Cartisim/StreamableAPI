import Vapor

//Write a Validation for Category before using to Content for decoding

extension Order.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("productName", as: String.self, is: !.empty)
        validations.add("imageString", as: String.self, is: !.empty)
         validations.add("currency", as: String.self, is: !.empty)
    }
}

extension Order {
    convenience init(from order: Order.Input) throws {
        self.init(productName: order.productName, imageString: order.imageString, currency: order.currency, quantity: order.quantity, price: order.price, isPurchased: order.isPurchased, videoid: order.videoid, userID: order.userID)
    }
}
