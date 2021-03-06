import Vapor

extension Video {
    struct _Output: Content {
        var id: String
        var title: String
        var price: Int
        var posterString: String
        var videoString: String
        var rating: String
        var time: String
        var description: String
        var genre: String

        init(id: String, title: String, price: Int, posterString: String, videoString: String, rating: String, time: String, description: String, genre: String) {
            self.id = id
            self.title = title
            self.price = price
            self.posterString = posterString
            self.videoString = videoString
            self.rating = rating
            self.time = time
            self.description = description
            self.genre = genre
        }
        
        init(from video: Video) {
            self.init(id: video.id!.uuidString, title: video.title, price: video.price, posterString: video.posterString, videoString: video.videoString, rating: video.rating, time: video.time, description: video.description, genre: video.genre)
        }
    }
}


