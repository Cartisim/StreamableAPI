import Vapor
import Fluent

final class OrderVideoPivot: Model {
    // Name of the table or collection.
    static let schema: String = "order_video"

    // Unique identifier for this pivot.
    @ID(key: .id)
    var id: UUID?

    // Reference to the Tag this pivot relates.
    @Parent(key: "order_id")
    var order: Order

    // Reference to the Star this pivot relates.
    @Parent(key: "video_id")
    var video: Video

    // Creates a new, empty pivot.
    init() {}

    // Creates a new pivot with all properties set.
    init(orderID: UUID, videoID: UUID) {
        self.order.id = orderID
        self.video.id = videoID
    }

}


