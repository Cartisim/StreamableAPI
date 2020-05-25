import Vapor

extension Order {
    struct _Input: Content {
        var productName: String
        var imageString: String
        var currency: String
        var quantity: Int
        var price: Int
        var isPurchased: Bool
        var videoid: String
        var userID: User.IDValue
        
        init(productName: String, imageString: String, currency: String, quantity: Int, price: Int, isPurchased: Bool, videoid: String, userID: User.IDValue) {
            self.productName = productName
            self.imageString = imageString
            self.currency = currency
            self.quantity = quantity
            self.price = price
            self.isPurchased = isPurchased
            self.videoid = videoid
            self.userID = userID
        }
        
        init(from order: Order) {
            self.init(productName: order.productName, imageString: order.imageString, currency: order.currency, quantity: order.quantity, price: order.price, isPurchased: order.isPurchased, videoid: order.videoid, userID: order.$user.id)
        }
    }
}

