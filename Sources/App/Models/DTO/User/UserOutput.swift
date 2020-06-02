import Vapor

extension User {
    struct _Output: Content {
        var id: String
        var username: String
        var email: String
        var profilePhotoString: String
        var isAdmin: Bool
        var isEmailVerified: Bool
        var order: [Order]
        
        init(id: String, username: String, email: String, profilePhotoString: String, isAdmin: Bool, isEmailVerified: Bool, order: [Order]) {
            self.id = id
            self.username = username
            self.email = email
            self.profilePhotoString = profilePhotoString
            self.isAdmin = isAdmin
            self.isEmailVerified = isEmailVerified
            self.order = order
        }
        
        init(from user: User) {
            self.init(id: user.id!.uuidString, username: user.username, email: user.email, profilePhotoString: user.profilePhotoString, isAdmin: user.isAdmin, isEmailVerified: user.isEmailVerified, order: user.order)
        }
    }
}
