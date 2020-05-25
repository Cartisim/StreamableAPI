import Vapor

extension Video {
    struct _Input: Content {
        var title: String
        var posterString: String
        var videoString: String
        var rating: String
        var time: String
        var description: String

        init(title: String, posterString: String, videoString: String, rating: String, time: String, description: String) {
            self.title = title
            self.posterString = posterString
            self.videoString = videoString
            self.rating = rating
            self.time = time
            self.description = description
        }
        
        init(from video: Video) {
            self.init(title: video.title, posterString: video.posterString, videoString: video.videoString, rating: video.rating, time: video.time, description: video.description)
        }
    }
}

