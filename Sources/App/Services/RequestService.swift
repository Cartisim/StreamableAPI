import Vapor

protocol RequestService {
    //using backtick on for reserves the word for special use
    func `for`(_ req: Request) -> Self
}
