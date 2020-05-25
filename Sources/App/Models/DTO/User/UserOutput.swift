import Vapor

extension User {
    struct _Output: Content {
        var id: String
        var username: String
        var email: String
        var profilePhotoString: String
        var isAdmin: Bool
        var isEmailVerified: Bool
    
        init(id: String, username: String, email: String, profilePhotoString: String, isAdmin: Bool, isEmailVerified: Bool) {
            self.id = id
        self.username = username
        self.email = email
        self.profilePhotoString = profilePhotoString
        self.isAdmin = isAdmin
        self.isEmailVerified = isEmailVerified
    }
    
    init(from user: User) {
        self.init(id: user.id!.uuidString, username: user.username, email: user.email, profilePhotoString: user.profilePhotoString, isAdmin: user.isAdmin, isEmailVerified: user.isEmailVerified)
    }
    }
}
