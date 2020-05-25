import Vapor

extension Video {
    struct _Output: Content {
        var id: String
        var title: String
        var posterString: String
        var videoString: String
        var rating: String
        var time: String
        var description: String

        init(id: String, title: String, posterString: String, videoString: String, rating: String, time: String, description: String) {
            self.id = id
            self.title = title
            self.posterString = posterString
            self.videoString = videoString
            self.rating = rating
            self.time = time
            self.description = description
        }
        
        init(from video: Video) {
            self.init(id: video.id!.uuidString, title: video.title, posterString: video.posterString, videoString: video.videoString, rating: video.rating, time: video.time, description: video.description)
        }
    }
}


