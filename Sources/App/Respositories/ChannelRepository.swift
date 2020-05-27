import Vapor
import Fluent

protocol ChannelRepository: Repository {
    func create(_ channel: Channel) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[Channel]>
    func find(id: UUID) -> EventLoopFuture<Channel?>
    func find(title: String) -> EventLoopFuture<Channel?>
    func set<Field>(_ field: KeyPath<Channel, Field>, to value: Field.Value, for channelID: UUID) -> EventLoopFuture<Void> where Field: FieldProtocol, Field.Model == Channel
    func count() -> EventLoopFuture<Int>
}

struct DatabaseChannelRepository: ChannelRepository, DatabaseRepository {
    let database: Database
    
    func create(_ channel: Channel) -> EventLoopFuture<Void> {
        return channel.create(on: database)
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return Channel.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[Channel]> {
        return Channel.query(on: database)
            .filter(\.$id == \._$id)
            .with(\.$subChannel) { child in
                child.with(\.$message)
        }
        .sort(\.$title, .descending).all()
    }
    
    func find(id: UUID) -> EventLoopFuture<Channel?> {
        return Channel.query(on: database)
            .filter(\.$id == id)
            .with(\.$subChannel) { child in
                child.with(\.$message)
        }
        .first()
    }
    
    func find(title: String) -> EventLoopFuture<Channel?> {
        return Channel.query(on: database)
            .filter(\.$title == title)
            .with(\.$subChannel) { child in
                child.with(\.$message)
        }
        .first()
    }
    
    func set<Field>(_ field: KeyPath<Channel, Field>, to value: Field.Value, for channelID: UUID) -> EventLoopFuture<Void>
        where Field: FieldProtocol, Field.Model == Channel
    {
        return Channel.query(on: database)
            .filter(\.$id == channelID)
            .set(field, to: value)
            .update()
    }
    
    func count() -> EventLoopFuture<Int> {
        return Channel.query(on: database).count()
    }
}

extension Application.Repositories {
    var channels: ChannelRepository {
        guard let storage = storage.makeChannelRepository else {
            fatalError("UserRepository not configured, use: app.categoriesRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (ChannelRepository)) {
        storage.makeChannelRepository = make
    }
}


