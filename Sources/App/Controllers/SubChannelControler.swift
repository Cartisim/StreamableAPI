import Vapor
import Fluent

struct SubChannelController {
    
    func postSubChannel(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try SubChannel.Input.validate(req)
        let subChannel = try req.content.decode(SubChannel.Input.self)
        let model = try SubChannel(from: subChannel)
        return req.subChannels
            .create(model)
            .transform(to: HTTPStatus.created)
    }
    
    
    func fetchEagerSubChannels(_ req: Request) throws -> EventLoopFuture<[SubChannel.Output]> {
        return req.subChannels
            .all()
            .map{ $0.map { SubChannel.Output(from: $0) } }
    }
    
    func fetchEagerSubChannel(_ req: Request) throws -> EventLoopFuture<SubChannel.Output> {
        guard let id = req.parameters.get(Constants.shared.SUB_CHANNEL_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.subChannels
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map {SubChannel.Output(from: $0)}
    }
    
    func deleteSubChannel(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.SUB_CHANNEL_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.subChannels
            .delete(id: id)
            .transform(to: .ok)
    }
}



