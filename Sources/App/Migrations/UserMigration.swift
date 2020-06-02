import Fluent
import Foundation
import Vapor

extension User {
    struct Migration: Fluent.Migration {
        
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user")
                .id()
                .field("username", .string, .required)
                .field("email", .string, .required)
                .field("password_hash", .string, .required)
                .field("profile_photo_string", .string, .required)
                .field("is_admin", .bool, .required, .custom("DEFAULT FALSE"))
                .field("is_email_verified", .bool, .required, .custom("DEFAULT FALSE"))
                .field("created_at", .datetime, .required)
                .unique(on: "email")
                .create()
        }
        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema("user").delete()
        }
        
        var name: String { "CreateUser" }
    }
}


struct AdminAccount: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        database.eventLoop.flatten([
//        Do Something
//                ])
//            .flatMap {

        let registerAdminRequest = RegisterAdminRequest(username: "Admin", email: "inquiry@cartisim.io", password: "password", confirmPassword: "password", isAdmin: true, isEmailVerified: true)
                let hashed =  try? Bcrypt.hash(registerAdminRequest.confirmPassword)
                guard let hashedPassword = hashed else {
                    fatalError("Failed to create admin user")
                }
        let user = try? User(from: registerAdminRequest, hash: hashedPassword)
                print(user)
                return (user?.save(on: database).transform(to: ()))!
    }
    
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return  database.schema("admin_user").delete()
    }
          var name: String { "AdminAccount" }
}


