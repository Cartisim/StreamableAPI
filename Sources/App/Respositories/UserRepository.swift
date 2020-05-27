import Vapor
import Fluent

//user repo protocol
protocol UserRepository: Repository {
    //3. protocols purpose is to have Custom CRUD methods
    func create(_ user: User) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[User]>
    func find(id: UUID) -> EventLoopFuture<User?>
    func find(email: String) -> EventLoopFuture<User?>
    func set<Field>(_ field: KeyPath<User, Field>, to value: Field.Value, for userID: UUID) -> EventLoopFuture<Void> where Field: FieldProtocol, Field.Model == User
    func count() -> EventLoopFuture<Int>
}

//conform dbur to userRepo and dbRepo protcols
struct DatabaseUserRepository: UserRepository, DatabaseRepository {
    let database: Database
    
    //4.write repo handlers
    func create(_ user: User) -> EventLoopFuture<Void> {
        return user.create(on: database)
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return User.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[User]> {
        return User.query(on: database)
            .filter(\.$id == \._$id)
                 .with(\.$order) { sibling in
                     sibling.with(\.$video)
             }
            .sort(\.$username, .descending)
            .all()
    }
    
    func find(id: UUID) -> EventLoopFuture<User?> {
        return User.query(on: database)
            .filter(\.$id == id)
            .with(\.$order) { sibling in
                sibling.with(\.$video)
        }
        .first()
    }
    
    func find(email: String) -> EventLoopFuture<User?> {
        return User.query(on: database)
            .filter(\.$email == email)
            .with(\.$order) { sib in
                sib.with(\.$video)
        }
        .first()
    }
    
    func set<Field>(_ field: KeyPath<User, Field>, to value: Field.Value, for userID: UUID) -> EventLoopFuture<Void> where Field : FieldProtocol, Field.Model == User {
        return User.query(on: database)
            .filter(\.$id == userID)
            .set(field, to: value)
            .update()
    }
    
    func count() -> EventLoopFuture<Int> {
        return User.query(on: database).count()
    }
}



//2. set up user repo
extension Application.Repositories {
    var users: UserRepository {
        guard let storage = storage.makeUserRepositroy else {
            fatalError("User Repo not configured, look in the services.swift file")
        }
        return storage(app)
    }
    func use(_ make: @escaping (Application) -> (UserRepository)) {
        storage.makeUserRepositroy = make
    }
}
