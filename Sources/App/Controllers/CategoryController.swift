import Vapor
import Fluent

struct CategoryController {
    
    func postCategory(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try Category.Input.validate(req)
        let category = try req.content.decode(Category.Input.self)
        let model = try Category(from: category)
        return req.categories
            .create(model)
            .transform(to: HTTPStatus.created)
    }
    
    
    func fetchEagerCategories(_ req: Request) throws -> EventLoopFuture<[Category.Output]> {
        return req.categories
            .all()
            .map{ $0.map { Category.Output(from: $0) } }
    }
    
    func fetchEagerCategory(_ req: Request) throws -> EventLoopFuture<Category.Output> {
        guard let id = req.parameters.get(Constants.shared.CATEGORY_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.categories
            .find(id: id)
            .unwrap(or: Abort(.notFound))
            .map {Category.Output(from: $0)}
    }
    
    func deleteCategory(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get(Constants.shared.CATEGORY_ID_STRING, as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.categories
        .delete(id: id)
            .transform(to: .ok)
    }
    
    func editCategory(_ request: Request) throws -> EventLoopFuture<Category.Input> {
        guard let id = request.parameters.get(Constants.shared.CATEGORY_ID_STRING, as: UUID.self) else { throw Abort(.badRequest) }
        let category = try request.content.decode(Category.Input.self)
        let foundCategory = Category.find(id, on: request.db)
        return foundCategory
            .unwrap(or: Abort(.notFound))
            .flatMap { updateCategory in
                updateCategory.categoryName = category.categoryName
                return updateCategory.save(on: request.db)
                    .map { Category.Input(categoryName: category.categoryName)
                }
        }
    }
    
    
    func addCourseToCategory(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        let category = Category.find(req.parameters.get(Constants.shared.CATEGORY_ID_STRING), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        let video = Video.find(req.parameters.get(Constants.shared.VIDEO_ID_STRING), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        return category.and(video).flatMap { (category, video) in
            category.$video.attach(video, on: req.db)
        }.transform(to: .ok)
    }
    
    func fetchCategoriesVideos(_ req: Request) throws -> EventLoopFuture<[Category.Output]> {
        Category.query(on: req.db)
            .with(\.$video)
        .all()
        .map{ $0.map { Category.Output(from: $0) } }
    }
    
    func fetchCategoryVideos(_ req: Request) throws -> EventLoopFuture<[Video.Output]> {
        let category = Category.find(req.parameters.get(Constants.shared.CATEGORY_ID_STRING), on: req.db)
            .unwrap(or: Abort(.notFound))
        return category
            .flatMap { (category) in
                category.$video.query(on: req.db)
                    .with(\.$category)
                    .all()
                    .map{ $0.map { Video.Output(from: $0) } }
        }
    }
    
}
