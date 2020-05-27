import Vapor

extension Request {
    var categories: CategoryRepository { application.repositories.categories.for(self) }
    var channels: ChannelRepository { application.repositories.channels.for(self) }
    var subChannels: SubChannelRepository { application.repositories.subChannels.for(self) }
    var messages: MessageRepository { application.repositories.messages.for(self) }
    var orders: OrderRepository { application.repositories.orders.for(self) }
    var videos: VideoRepository { application.repositories.videos.for(self) }
    var users: UserRepository { application.repositories.users.for(self) }
    var refreshTokens: RefreshTokenRepository { application.repositories.refreshTokens.for(self) }
    var emailTokens: EmailTokenRepository { application.repositories.emailTokens.for(self) }
    var passwordTokens: PasswordTokenRepository { application.repositories.passwordTokens.for(self) }
}
