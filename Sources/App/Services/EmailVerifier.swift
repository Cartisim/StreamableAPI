import Vapor
import Queues

struct EmailVerifier {
    let emailTokenRepository: EmailTokenRepository
    let config: AppConfig
    let queue: Queue
    let eventLoop: EventLoop
    let generator: RandomGenerator
    
    func verify(for user: User) -> EventLoopFuture<Void> {
        do {
            let token = generator.generate(bits: 256)
            let emailToken = try EmailToken(userID: user.requireID(), token: SHA256.hash(token))
            let verifyUrl = url(token: token)
            print(verifyUrl, "Verify Email URL")
            return emailTokenRepository.create(emailToken).flatMap {
                self.queue.dispatch(EmailJob.self, .init(VerificationEmail(verifyUrl: verifyUrl), to: user.email))
            }
        } catch {
            return eventLoop.makeFailedFuture(error)
        }
    }
    
    private func url(token: String) -> String {
//         #"\#(config.apiURLTest)/api/auth/email-verification?token=\#(token)"#
         #"\#(config.apiURL)/emailVerification?token=\#(token)"#
    }
}

extension Application {
    var emailVerifier: EmailVerifier {
        .init(emailTokenRepository: self.repositories.emailTokens, config: self.config, queue: self.queues.queue, eventLoop: eventLoopGroup.next(), generator: self.random)
    }
}

extension Request {
    var emailVerifier: EmailVerifier {
        .init(emailTokenRepository: self.emailTokens, config: application.config, queue: self.queue, eventLoop: eventLoop, generator: self.application.random)
    }
}



