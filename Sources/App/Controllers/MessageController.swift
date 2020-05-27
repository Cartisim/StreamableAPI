import Vapor
import Fluent

struct MessageController {
    
    func postMessage(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try Message.Input.validate(req)
        let message = try req.content.decode(Message.Input.self)
        let model = try Message(from: message)
        return req.messages
            .create(model)
            .transform(to: HTTPStatus.created)
    }
    
    
    func fetchEagerMessages(_ req: Request) throws -> EventLoopFuture<[Message.Output]> {
        return req.messages
            .all()
            .map{ $0.map { Message.Output(from: $0) } }
    }
    
    func fetchEagerMessage(_ req: Request) throws -> EventLoopFuture<Message.Output> {
        guard let id = req.parameters.get(Constants.shared.MESSAGE_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.messages
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map {Message.Output(from: $0)}
    }
    
    func deleteMessage(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.MESSAGE_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.messages
            .delete(id: id)
            .transform(to: .ok)
    }
}


