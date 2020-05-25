import Vapor
import Fluent

final class UserChannelPivot: Model {
    // Name of the table or collection.
    static let schema: String = "user_project"

    // Unique identifier for this pivot.
    @ID(key: .id)
    var id: UUID?

    // Reference to the Tag this pivot relates.
    @Parent(key: "user_id")
    var user: User

    // Reference to the Star this pivot relates.
    @Parent(key: "channel_id")
    var channel: Channel

    // Creates a new, empty pivot.
    init() {}

    // Creates a new pivot with all properties set.
    init(userID: UUID, channelID: UUID) {
        self.user.id = userID
        self.channel.id = channelID
    }

}

