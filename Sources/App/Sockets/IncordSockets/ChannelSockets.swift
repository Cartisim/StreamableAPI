import Fluent
import Vapor
import Foundation

func sockets(_ app: Application) throws {
     app.webSocket("api") { req, ws in
        print("Connected to Web Socket")

        ws.onText { (ws, text) in
            ws.send("Connected to Websocket \(text)")
        }
    }

     app.webSocket("api", "channel") { req, ws in
        print("Channel Connected, \(ws)")

        ws.onBinary{ (ws, data) in
            guard let unwrappedBuffer = data.getBytes(at: .max, length: .max) else {return}
            print(unwrappedBuffer, "print buffer")
            ws.send(unwrappedBuffer)
            do {
                let recevied = try JSONDecoder().decode(Channel.self, from: data)
                let channel = Channel(imageString: recevied.imageString, title: recevied.title)
                let _ = channel.save(on: req.db)
            } catch let error {
                print("error \(error)")
            }
        }
    }

//     app.webSocket("api/end_point") { req, ws in
//        ws.onBinary{ (ws, data) in
//            ws.send(data)
//            do {
//                let received = try JSONDecoder().decode(Database.self, from: data)
//                print(received)
//                let model = Database(title: received.title)
//                let _ = model.save(on: req)
//            } catch let error {
//                print("Error: \(error)")
//            }
//        }
//    }
//
//     app.webSocket("api/messages") { (req, ws) in
//        print("Message Connected")
//
//        ws.onBinary { (ws, data) in
//            ws.send(data)
//            do {
//                let received = try JSONDecoder().decode(Message.self, from: data)
//                print(data.convertToHTTPBody())
//                let message = Message(avatar: received.avatar, username: received.username, date: received.date, message: received.message, subChannelID: received.subChannelID, createAccountID: received.createAccountID)
//                let _ = message.save(on: req)
//            } catch let error {
//                print("Error: \(error)")
//            }
//        }
//    }
//
//

}

