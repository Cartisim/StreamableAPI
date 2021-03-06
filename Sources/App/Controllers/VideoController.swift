import Vapor
import Fluent

struct VideoController {
    
    func postVideo(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try Video.Input.validate(req)
        let video = try req.content.decode(Video.Input.self)
        let model = try Video(from: video)
        return req.videos
            .create(model)
            .transform(to: HTTPStatus.created)
    }
    
    
    func fetchEagerVideos(_ req: Request) throws -> EventLoopFuture<[Video.Output]> {
        return req.videos
            .all()
            .map{ $0.map { Video.Output(from: $0) } }
    }
    
    func fetchEagerVideo(_ req: Request) throws -> EventLoopFuture<Video.Output> {
        guard let id = req.parameters.get(Constants.shared.VIDEO_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.videos
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map {Video.Output(from: $0)}
    }
    
    func deleteVideo(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.VIDEO_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.videos
            .delete(id: id)
            .transform(to: .ok)
    }
    
    func editVideo(_ request: Request) throws -> EventLoopFuture<Video.Input> {
        guard let id = request.parameters.get(Constants.shared.VIDEO_ID_STRING, as: UUID.self) else { throw Abort(.badRequest) }
        let video = try request.content.decode(Video.Input.self)
        let foundCourse = Video.find(id, on: request.db)
        return foundCourse
            .unwrap(or: Abort(.notFound))
            .flatMap { updateVideo in
                updateVideo.title = video.title
                updateVideo.price = video.price
                 updateVideo.posterString = video.posterString
                 updateVideo.videoString = video.videoString
                 updateVideo.rating = video.rating
                 updateVideo.time = video.time
                 updateVideo.description = video.description
                updateVideo.genre = video.genre
                return updateVideo.save(on: request.db)
                    .map { Video.Input(title: updateVideo.title, price: updateVideo.price, posterString: updateVideo.posterString, videoString: updateVideo.videoString, rating: updateVideo.rating, time: updateVideo.time, description: updateVideo.description, genre: updateVideo.genre)
                }
        }
    }
}



