import Vapor

struct AccessTokenRequest: Content {
    let refeshToken: String
}
