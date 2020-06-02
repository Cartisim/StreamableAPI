import Vapor
import Fluent

protocol OrderRepository: Repository {
    func create(_ order: Order) -> EventLoopFuture<Void>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[Order]>
    func find(id: UUID?) -> EventLoopFuture<Order?>
    func set<Field>(_ field: KeyPath<Order, Field>, to value: Field.Value, for orderID: UUID) -> EventLoopFuture<Void> where Field: FieldProtocol, Field.Model == Order
    func count() -> EventLoopFuture<Int>
}

struct DatabaseOrderRepository: OrderRepository, DatabaseRepository {
    let database: Database
    
        func create(_ order: Order) -> EventLoopFuture<Void> {
            return order.create(on: database)
        }
        
        func delete(id: UUID) -> EventLoopFuture<Void> {
            return Order.query(on: database)
                .filter(\.$id == id)
                .delete()
        }
        
        func all() -> EventLoopFuture<[Order]> {
            return Order.query(on: database)
                .filter(\.$id == \._$id)
                                .with(\.$video)
                .sort(\.$createdAt, .descending).all()
        }
        
        func find(id: UUID?) -> EventLoopFuture<Order?> {
            return Order.find(id, on: database)
        }
        
        func set<Field>(_ field: KeyPath<Order, Field>, to value: Field.Value, for orderID: UUID) -> EventLoopFuture<Void>
            where Field: FieldProtocol, Field.Model == Order
        {
            return Order.query(on: database)
                .filter(\.$id == orderID)
                .set(field, to: value)
                .update()
        }
        
        func count() -> EventLoopFuture<Int> {
            return Order.query(on: database).count()
        }
    }

    extension Application.Repositories {
        var orders: OrderRepository {
            guard let storage = storage.makeOrderRepository else {
                fatalError("UserRepository not configured, use: app.categoriesRepository.use()")
            }
            
            return storage(app)
        }
        
        func use(_ make: @escaping (Application) -> (OrderRepository)) {
            storage.makeOrderRepository = make
        }
    }


