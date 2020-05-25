import Vapor

extension Order {
    struct _Output: Content {
        var id: String
        var productName: String
        var imageString: String
        var currency: String
        var quantity: Int
        var price: Int
        var isPurchased: Bool
        var videoid: String
        var userID: User.IDValue
        var video: [Video]
        
        init(id: String, productName: String, imageString: String, currency: String, quantity: Int, price: Int, isPurchased: Bool, videoid: String, userID: User.IDValue, video: [Video]) {
            self.id = id
            self.productName = productName
            self.imageString = imageString
            self.currency = currency
            self.quantity = quantity
            self.price = price
            self.isPurchased = isPurchased
            self.videoid = videoid
            self.userID = userID
            self.video = video
        }
        
        init(from order: Order) {
            self.init(id: order.id!.uuidString, productName: order.productName, imageString: order.imageString, currency: order.currency, quantity: order.quantity, price: order.price, isPurchased: order.isPurchased, videoid: order.videoid, userID: order.$user.id, video: order.video)
        }
    }
}
