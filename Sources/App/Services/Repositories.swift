import Vapor
import Fluent

//create a protocol that conforms to our RequestService
protocol Repository: RequestService {}

//create a  database repo protocol that coforms to our Repository Protocol
protocol DatabaseRepository: Repository {
    var database: Database { get }
    init(database: Database)
}

extension DatabaseRepository {
    func `for`(_ req: Request) -> Self {
        return Self.init(database: req.db)
    }
}

//The Repositories that the application will use, run that app
extension Application {
    struct Repositories {
        struct Provider {
            static var database: Self {
                .init {
                    $0.repositories.use { DatabaseUserRepository(database: $0.db) }
                    $0.repositories.use { DatabaseEmailTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseRefreshTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabasePasswordTokenRepository(database: $0.db) }
                    $0.repositories.use { DatabaseCategoryRepository(database: $0.db) }
                    $0.repositories.use { DatabaseChannelRepository(database: $0.db) }
                    $0.repositories.use { DatabaseSubChannelRepository(database: $0.db) }
                    $0.repositories.use { DatabaseVideoRepository(database: $0.db) }
                    $0.repositories.use { DatabaseMessageRepository(database: $0.db) }
                    $0.repositories.use { DatabaseOrderRepository(database: $0.db) }
                }
            }
            let run: (Application) -> ()
        }
        
        //make the repo then store it
        //Start here after setting up repo
        //1.
        final class Storage {
            var makeUserRepositroy: ((Application) -> UserRepository)?
            var makeEmailTokenRepository: ((Application) -> EmailTokenRepository)?
            var makeRefreshTokenRepository: ((Application) -> RefreshTokenRepository)?
            var makePasswordTokenRepository: ((Application) -> PasswordTokenRepository)?
            var makeCategoryRepository: ((Application) -> CategoryRepository)?
            var makeChannelRepository: ((Application) -> ChannelRepository)?
            var makeSubChannelRepository: ((Application) -> SubChannelRepository)?
            var makeMessageRepository: ((Application) -> MessageRepository)?
            var makeVideoRepository: ((Application) -> VideoRepository)?
            var makeOrderRepository: ((Application) -> OrderRepository)?
            init() {}
        }
        
        //Our Key value is from our storage
        struct Key: StorageKey {
            typealias Value = Storage
        }
        
        //App instance
        let app: Application
        
        //use the app and run it
        func use(_ provider: Provider) {
            provider.run(app)
        }
        
        //Set the value of our storage
        var storage: Storage {
            if app.storage[Key.self] == nil {
                app.storage[Key.self] = .init()
            }
            return app.storage[Key.self]!
        }
    }
    
    
    var repositories: Repositories {
        .init(app: self)
    }
}
