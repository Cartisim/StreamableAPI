import Vapor
import Fluent

protocol CategoryRepository: Repository {
    func create(_ category: Category) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[Category]>
    func find(id: UUID) -> EventLoopFuture<Category?>
    func find(categoryName: String) -> EventLoopFuture<Category?>
    func set<Field>(_ field: KeyPath<Category, Field>, to value: Field.Value, for categoryID: UUID) -> EventLoopFuture<Void> where Field: FieldProtocol, Field.Model == Category
    func count() -> EventLoopFuture<Int>
}

struct DatabaseCategoryRepository: CategoryRepository, DatabaseRepository {
    let database: Database
    
    func create(_ category: Category) -> EventLoopFuture<Void> {
        return category.create(on: database)
    }
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return Category.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[Category]> {
        return Category.query(on: database)
             .filter(\.$id == \._$id)
            .with(\.$video)
            .sort(\.$categoryName, .descending).all()
    }

    
    func find(id: UUID) -> EventLoopFuture<Category?> {
        return Category.query(on: database)
            .filter(\.$id == id)
            .with(\.$video)
            .first()
    }
    
    func find(categoryName: String) -> EventLoopFuture<Category?> {
        return Category.query(on: database)
            .filter(\.$categoryName == categoryName)
            .with(\.$video) { sibling in
                sibling.with(\.$order) { sibling in
                    sibling.with(\.$user)
                }
        }
        .first()
    }
    
    func set<Field>(_ field: KeyPath<Category, Field>, to value: Field.Value, for categoryID: UUID) -> EventLoopFuture<Void>
        where Field: FieldProtocol, Field.Model == Category
    {
        return Category.query(on: database)
            .filter(\.$id == categoryID)
            .set(field, to: value)
            .update()
    }
    
    func count() -> EventLoopFuture<Int> {
        return Category.query(on: database).count()
    }
}

extension Application.Repositories {
    var categories: CategoryRepository {
        guard let storage = storage.makeCategoryRepository else {
            fatalError("UserRepository not configured, use: app.categoriesRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (CategoryRepository)) {
        storage.makeCategoryRepository = make
    }
}

