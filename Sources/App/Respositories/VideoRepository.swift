import Vapor
import Fluent

protocol VideoRepository: Repository {
    func create(_ video: Video) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[Video]>
    func find(id: UUID?) -> EventLoopFuture<Video?>
    func find(title: String) -> EventLoopFuture<Video?>
    func set<Field>(_ field: KeyPath<Video, Field>, to value: Field.Value, for categoryID: UUID) -> EventLoopFuture<Void> where Field: FieldProtocol, Field.Model == Video
    func count() -> EventLoopFuture<Int>
}

struct DatabaseVideoRepository: VideoRepository, DatabaseRepository {
    let database: Database
    
        func create(_ video: Video) -> EventLoopFuture<Void> {
            return video.create(on: database)
        }
        
        func delete(id: UUID) -> EventLoopFuture<Void> {
            return Video.query(on: database)
                .filter(\.$id == id)
                .delete()
        }
        
        func all() -> EventLoopFuture<[Video]> {
            return Video.query(on: database)
                .sort(\.$title, .descending).all()
        }
        
        func find(id: UUID?) -> EventLoopFuture<Video?> {
            return Video.find(id, on: database)
        }
        
        func find(title: String) -> EventLoopFuture<Video?> {
            return Video.query(on: database)
                .filter(\.$title == title)
                .first()
        }
        
        func set<Field>(_ field: KeyPath<Video, Field>, to value: Field.Value, for videoID: UUID) -> EventLoopFuture<Void>
            where Field: FieldProtocol, Field.Model == Video
        {
            return Video.query(on: database)
                .filter(\.$id == videoID)
                .set(field, to: value)
                .update()
        }
        
        func count() -> EventLoopFuture<Int> {
            return Video.query(on: database).count()
        }
    }

    extension Application.Repositories {
        var videos: VideoRepository {
            guard let storage = storage.makeVideoRepository else {
                fatalError("UserRepository not configured, use: app.categoriesRepository.use()")
            }
            
            return storage(app)
        }
        
        func use(_ make: @escaping (Application) -> (VideoRepository)) {
            storage.makeVideoRepository = make
        }
    }


