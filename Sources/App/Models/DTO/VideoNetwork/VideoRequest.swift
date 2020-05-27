import Vapor

//Write a Validation for Category before using to Content for decoding

extension Video.Input: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("posterString", as: String.self, is: !.empty)
        validations.add("videoString", as: String.self, is: !.empty)
        validations.add("rating", as: String.self, is: !.empty)
        validations.add("time", as: String.self, is: !.empty)
        validations.add("description", as: String.self, is: !.empty)
    }
}

extension Video {
    convenience init(from video: Video.Input) throws {
        self.init(title: video.title, posterString: video.posterString, videoString: video.videoString, rating: video.rating, time: video.time, description: video.description)
    }
}
