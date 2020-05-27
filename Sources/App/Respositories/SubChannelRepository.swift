import Vapor
import Fluent

protocol SubChannelRepository: Repository {
    func create(_ subChannel: SubChannel) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[SubChannel]>
    func find(id: UUID) -> EventLoopFuture<SubChannel?>
    func find(title: String) -> EventLoopFuture<SubChannel?>
    func set<Field>(_ field: KeyPath<SubChannel, Field>, to value: Field.Value, for subChannelID: UUID) -> EventLoopFuture<Void> where Field: FieldProtocol, Field.Model == SubChannel
    func count() -> EventLoopFuture<Int>
}

struct DatabaseSubChannelRepository: SubChannelRepository, DatabaseRepository {
    let database: Database
    
    func create(_ subChannel: SubChannel) -> EventLoopFuture<Void> {
        return subChannel.create(on: database)
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return SubChannel.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[SubChannel]> {
        return SubChannel.query(on: database)
            .filter(\.$id == \._$id)
            .with(\.$message)
            .sort(\.$title, .descending).all()
    }
    
    func find(id: UUID) -> EventLoopFuture<SubChannel?> {
        return SubChannel.query(on: database)
            .filter(\.$id == id)
            .with(\.$message)
            .first()
    }
    
    func find(title: String) -> EventLoopFuture<SubChannel?> {
        return SubChannel.query(on: database)
            .filter(\.$title == title)
            .with(\.$message)
            .first()
    }
    
    func set<Field>(_ field: KeyPath<SubChannel, Field>, to value: Field.Value, for subChannelID: UUID) -> EventLoopFuture<Void>
        where Field: FieldProtocol, Field.Model == SubChannel
    {
        return SubChannel.query(on: database)
            .filter(\.$id == subChannelID)
            .set(field, to: value)
            .update()
    }
    
    func count() -> EventLoopFuture<Int> {
        return SubChannel.query(on: database).count()
    }
}

extension Application.Repositories {
    var subChannels: SubChannelRepository {
        guard let storage = storage.makeSubChannelRepository else {
            fatalError("UserRepository not configured, use: app.subChannelRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (SubChannelRepository)) {
        storage.makeSubChannelRepository = make
    }
}


