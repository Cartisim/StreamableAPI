import Vapor
import Fluent

protocol MessageRepository: Repository {
    func create(_ category: Message) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[Message]>
    func find(id: UUID?) -> EventLoopFuture<Message?>
    func find(username: String) -> EventLoopFuture<Message?>
    func set<Field>(_ field: KeyPath<Message, Field>, to value: Field.Value, for categoryID: UUID) -> EventLoopFuture<Void> where Field: FieldProtocol, Field.Model == Message
    func count() -> EventLoopFuture<Int>
}

struct DatabaseMessageRepository: MessageRepository, DatabaseRepository {
    let database: Database
    
        func create(_ message: Message) -> EventLoopFuture<Void> {
            return message.create(on: database)
        }
        
        func delete(id: UUID) -> EventLoopFuture<Void> {
            return Message.query(on: database)
                .filter(\.$id == id)
                .delete()
        }
        
        func all() -> EventLoopFuture<[Message]> {
            return Message.query(on: database)
                .sort(\.$username, .descending).all()
        }
        
        func find(id: UUID?) -> EventLoopFuture<Message?> {
            return Message.find(id, on: database)
        }
        
        func find(username: String) -> EventLoopFuture<Message?> {
            return Message.query(on: database)
                .filter(\.$username == username)
                .first()
        }
        
        func set<Field>(_ field: KeyPath<Message, Field>, to value: Field.Value, for messageID: UUID) -> EventLoopFuture<Void>
            where Field: FieldProtocol, Field.Model == Message
        {
            return Message.query(on: database)
                .filter(\.$id == messageID)
                .set(field, to: value)
                .update()
        }
        
        func count() -> EventLoopFuture<Int> {
            return Message.query(on: database).count()
        }
    }

    extension Application.Repositories {
        var messages: MessageRepository {
            guard let storage = storage.makeMessageRepository else {
                fatalError("UserRepository not configured, use: app.categoriesRepository.use()")
            }
            
            return storage(app)
        }
        
        func use(_ make: @escaping (Application) -> (MessageRepository)) {
            storage.makeMessageRepository = make
        }
    }


