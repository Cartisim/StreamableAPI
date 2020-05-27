import Vapor

public final class PurchasedMiddleware: Middleware {
    
    public func respond(to request: Request, chainingTo next: Responder)  -> EventLoopFuture<Response> {
        let order = Order.find(request.parameters.get(Constants.shared.ORDER_ID_STRING), on: request.db)
            .unwrap(or: Abort(.notFound))
        return order.flatMap { (order) in
            if order.isPurchased == false {
                return request.eventLoop.future(error: Abort(.unauthorized))
            }
            return next.respond(to: request)
        }
    }
}

