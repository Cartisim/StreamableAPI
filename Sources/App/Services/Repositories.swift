import Vapor
import Fluent

//create a protocol that conforms to our RequestService
protocol Repository: RequestService {}

//create a  database repo protocol that coforms to our Repository Protocol
protocol DataBaseRepository: Repository {
    var database: Database { get }
    init(database: Database)
}

//The Repositories that the application will use
struct Repositories {
    struct Provider {
        static var database: Self {
            .init {
                
                
                
            }
        }
    }
    
    //make the repo then store it
    final class Storage {
        
    }
    
    //Our Key value is from our storage
    struct Key: StorageKey {
        typealias Value = Storage
    }
    
    let app: Application
    
    func use(_ provider: Provider) {
        provider.run(app)
    }
    
    //Set the value of our storage
    var storage: Storage {
        if app.storage[Key.self] == nil {
            app.storage.[Key.self] = .init()
        }
        return app.storage[Key.self]
    }
}

var repositories: Repositories {
    .init(app: self)
}
