import Vapor

func migrations(_ app: Application) throws {
    app.migrations.add(User.Migration())
    app.migrations.add(AdminAccount())
    app.migrations.add(CreatePasswordToken())
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(Channel.Migration())
    app.migrations.add(CreateUserChannelPivot())
    app.migrations.add(Order.Migration())
    app.migrations.add(Video.Migration())
    app.migrations.add(CreateOrderVideoPivot())
    app.migrations.add(Category.Migration())
    app.migrations.add(CreateCategoryVideoPivot())
    app.migrations.add(SubChannel.Migration())
    app.migrations.add(Message.Migration())
    
}
