import Vapor

struct LoginResponse: Content {
    let user: User.Output
    let accessToken: String
    let refreshToken: String
}
