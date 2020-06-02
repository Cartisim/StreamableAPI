import Vapor
import FluentPostgresDriver
import Fluent
import JWT
import Mailgun
import QueuesRedisDriver

// configures your application
public func configure(_ app: Application) throws {
    
    
    //Setup service to sign JWT
    if app.environment != .testing {
        //Be sure to edit the scheme for the working directory of the project(the root project folder)
        let jwksFilePath = app.directory.workingDirectory + (Environment.get("JWKS_KEYPAIR_FILE") ?? "keypair.jwks")
        guard let jwks = FileManager.default.contents(atPath: jwksFilePath),
            let jwksString = String(data: jwks, encoding: .utf8)
     else {
        fatalError("Failed to load JWKS Keypair File at: \(jwksFilePath)")
    }
    try app.jwt.signers.use(jwksJSON: jwksString)
}
 
    //Setup Postgres DB
    app.databases.use(
        .postgres(
            hostname: Environment.get("HOSTNAME") ?? "",
            username: Environment.get("USERNAME") ?? "",
            password: Environment.get("PASSWORD") ?? "",
            database: Environment.get("DATABASE") ?? ""
        ),
        as: .psql)
    
    
    //Middlewares
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .OPTIONS, .DELETE, .PUT],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    app.middleware = .init()
    app.middleware.use(corsMiddleware)
    app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    
    // MARK: Mailgun
    app.mailgun.configuration = .environment
    app.mailgun.defaultDomain = .sandbox
    
//        // Create a new NIO websocket server
//        let wss = NIOWebSocketServer.default()
//        try socketRouter(wss)
//        // Register our server
//    
//        services.register(wss, as: WebSocketServer.self)
    
    //Configure App
    app.config = .environment
    
    try routes(app)
    try sockets(app)
    try migrations(app)
    try queues(app)
    try services(app)
    
    if app.environment == .development {
        try app.autoMigrate().wait()
    }
        print(app.routes.all)
}
