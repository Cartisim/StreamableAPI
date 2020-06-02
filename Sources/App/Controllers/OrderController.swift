import Vapor
import Fluent

struct OrderController {
    
    func postOrder(_ req: Request) throws -> EventLoopFuture<Response> {
        try Order.Input.validate(req)
        let order = try req.content.decode(Order.Input.self)
        let model = try Order(from: order)
      
        return req.orders
            .create(model)
            .map { res in
                return Response(status: .ok, body: Response.Body(string: model.id?.uuidString ?? ""))
        }
    }
    
    
    func fetchEagerOrders(_ req: Request) throws -> EventLoopFuture<[Order.Output]> {
        return req.orders
            .all()
            .map{ $0.map { Order.Output(from: $0) } }
    }
    
    func fetchEagerOrder(_ req: Request) throws -> EventLoopFuture<Order.Output> {
        guard let id = req.parameters.get(Constants.shared.ORDER_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.orders
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map {Order.Output(from: $0)}
    }
    
    func deleteOrder(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.ORDER_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.orders
            .delete(id: id)
            .transform(to: .ok)
    }
    
    func addVideoToOrder(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        let order = Order.find(req.parameters.get(Constants.shared.ORDER_ID_STRING), on: req.db)
            .unwrap(or: Abort(.notFound))
        let video = Video.find(req.parameters.get(Constants.shared.VIDEO_ID_STRING), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        return order.and(video).flatMap { (order, video) in
            order.$video.attach(video, on: req.db)
        }.transform(to: .ok)
    }
}



