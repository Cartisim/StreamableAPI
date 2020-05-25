
struct Constants {
    static let shared = Constants()
    
    let RESET_PASSWORD_TOKEN_LIFETIME: Double = 60 * 60
    let REFRESH_TOKEN_LIFETIME: Double = 60 * 60 * 24 * 7
    let ACCESS_TOKEN_LIFETIME: Double = 60 * 60 * 2
    let EMAIL_TOKEN_LIFETIME: Double = 60 * 60 * 24
}
