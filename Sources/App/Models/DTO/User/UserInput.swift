import Vapor

extension User {
    struct _Input: Content {
        var username: String
        var email: String
        var profilePhotoString: String
        var isAdmin: Bool
        var isEmailVerified: Bool
    
        init(username: String, email: String, profilePhotoString: String, isAdmin: Bool, isEmailVerified: Bool) {
        self.username = username
        self.email = email
        self.profilePhotoString = profilePhotoString
        self.isAdmin = isAdmin
        self.isEmailVerified = isEmailVerified
    }
    
    init(from user: User) {
        self.init(username: user.username, email: user.email, profilePhotoString: user.profilePhotoString, isAdmin: user.isAdmin, isEmailVerified: user.isEmailVerified)
    }
    }
}
