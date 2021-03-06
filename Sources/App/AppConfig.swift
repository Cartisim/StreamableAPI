import Vapor

struct AppConfig {
    let apiURL: String
    let apiURLTest: String
    let noReplyEmail: String
    
    static var environment: AppConfig {
        guard
            let apiURL = Environment.get("API_URL"),
            let apiURLTest = Environment.get("API_URL_TEST"),
            let noReplyEmail = Environment.get("NO_REPLY_EMAIL")
            
            else {
                fatalError("Plese add app configuration to the environment variables")
        }
        
        return .init(apiURL: apiURL, apiURLTest: apiURLTest, noReplyEmail: noReplyEmail)
    }
}

extension Application {
    struct AppConfigKey: StorageKey {
        typealias Value = AppConfig
    }
    
    var config: AppConfig {
        get {
            storage[AppConfigKey.self] ?? .environment
        }
        set {
            storage[AppConfigKey.self] = newValue
        }
    }
}
