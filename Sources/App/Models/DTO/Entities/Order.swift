import Vapor
import Fluent

final class Order: Codable, Model {
    
    typealias Input = _Input
    typealias Output = _Output
    
    static let schema = "order"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "product_name")
    var productName: String
    
    @Field(key: "image_string")
    var imageString: String
    
    @Field(key: "currency")
    var currency: String
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "price")
    var price: Int
    
    @Field(key: "is_purchased")
    var isPurchased: Bool
    
    @Field(key: "videoid")
    var videoid: String
    
    @Parent(key: "user_id")
    var user: User
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Siblings(through: OrderVideoPivot.self, from: \.$order, to: \.$video)
    var video: [Video]
    
       init() {}
    
    init(id: UUID? = nil, productName: String, imageString: String, currency: String, quantity: Int, price: Int, isPurchased: Bool, videoid: String, userID: User.IDValue) {
        self.id = id
        self.productName = productName
        self.imageString = imageString
        self.currency = currency
        self.quantity = quantity
        self.price = price
        self.isPurchased = isPurchased
        self.videoid = videoid
        self.user.id = userID
    }
    
}
