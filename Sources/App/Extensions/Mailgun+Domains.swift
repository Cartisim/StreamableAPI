import Mailgun

extension MailgunDomain {
    static var sandbox: MailgunDomain { .init("example.com", .us)}
}
