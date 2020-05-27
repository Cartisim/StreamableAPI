import Vapor

public final class AdminMiddleware: Middleware {
    
    public func respond(to request: Request, chainingTo next: Responder)  -> EventLoopFuture<Response> {
         let user = request.auth.get(Payload.self)
        if user?.isAdmin == false || user == nil {
             return request.eventLoop.future(error: Abort(.unauthorized))
        }
        return next.respond(to: request)
    }
}

