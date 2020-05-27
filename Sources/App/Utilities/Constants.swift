import Vapor

struct Constants {
    static let shared = Constants()
    
    //Token Lifetimes
    let RESET_PASSWORD_TOKEN_LIFETIME: Double = 60 * 60
    let REFRESH_TOKEN_LIFETIME: Double = 60 * 60 * 24 * 7
    let ACCESS_TOKEN_LIFETIME: Double = 60 * 60 * 2
    let EMAIL_TOKEN_LIFETIME: Double = 60 * 60 * 24
    
    //Variables
    let TOKEN = "token"
    
    //Endpoints
    let BASE = PathComponent(stringLiteral: "api")
    let AUTH_ROUTE = PathComponent(stringLiteral: "auth")
    let REGISTER = PathComponent(stringLiteral: "register")
    let LOGIN = PathComponent(stringLiteral: "login")
    let CURRENT_USER = PathComponent(stringLiteral: "currentUser")
    let USER = PathComponent(stringLiteral: "user")
    let USER_ID = PathComponent(stringLiteral: ":userID")
    let USER_ID_STRING = "userID"
    let ALL = PathComponent(stringLiteral: "all")
    let EDIT_CURRENT_USER = PathComponent(stringLiteral: "editCurrentUser")
    let EDIT_USER = PathComponent(stringLiteral: "editUser")
    let DELETE_USER = PathComponent(stringLiteral: "deleteUser")
    let DELETE_CURRENT_USER = PathComponent(stringLiteral: "deleteCurrentUser")
    let CATEGORY = PathComponent(stringLiteral: "category")
    let CATEGORY_ID = PathComponent(stringLiteral: ":categoryID")
    let CATEGORY_ID_STRING = "categoryID"
    let CATEGORY_VIDEO = PathComponent(stringLiteral: "categoryVideos")
    let CHANNEL = PathComponent(stringLiteral: "channel")
    let CHANNEL_ID = PathComponent(stringLiteral: ":channelID")
    let CHANNEL_ID_STRING = "channelID"
    let SUB_CHANNEL = PathComponent(stringLiteral: "subChannel")
    let SUB_CHANNEL_ID = PathComponent(stringLiteral: ":subChannelID")
    let SUB_CHANNEL_ID_STRING = "subChannelID"
    let MESSAGE = PathComponent(stringLiteral: "message")
    let MESSAGE_ID = PathComponent(stringLiteral: ":messageID")
    let MESSAGE_ID_STRING = "messageID"
    let ORDER = PathComponent(stringLiteral: "order")
    let ORDER_ID = PathComponent(stringLiteral: ":orderID")
    let ORDER_ID_STRING = "orderID"
    let VIDEO = PathComponent(stringLiteral: "video")
    let VIDEO_ID = PathComponent(stringLiteral: ":videoID")
    let VIDEO_ID_STRING = "videoID"
      let VIDEO_ORDER = PathComponent(stringLiteral: "videoOrder")
    let EMAIL_VERIFICATION = PathComponent(stringLiteral: "email-verification")
      let REST_PASSWORD = PathComponent(stringLiteral: "reset-password")
      let VERIFY = PathComponent(stringLiteral: "verify")
      let RECOVER = PathComponent(stringLiteral: "recover")
      let ACCESS_TOKEN = PathComponent(stringLiteral: "accessToken")
}
