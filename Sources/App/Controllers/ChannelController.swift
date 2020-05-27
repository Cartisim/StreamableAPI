import Vapor
import Fluent

struct ChannelController {
    
    func postChannel(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try Channel.Input.validate(req)
        let channel = try req.content.decode(Channel.Input.self)
        let model = try Channel(from: channel)
        return req.channels
            .create(model)
            .transform(to: HTTPStatus.created)
    }
    
    
    func fetchEagerChannels(_ req: Request) throws -> EventLoopFuture<[Channel.Output]> {
        return req.channels
            .all()
            .map{ $0.map { Channel.Output(from: $0) } }
    }
    
    func fetchEagerChannel(_ req: Request) throws -> EventLoopFuture<Channel.Output> {
        guard let id = req.parameters.get(Constants.shared.CHANNEL_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.channels
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map {Channel.Output(from: $0)}
    }
    
    func deleteChannel(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.CHANNEL_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.channels
        .delete(id: id)
            .transform(to: .ok)
    }
}

