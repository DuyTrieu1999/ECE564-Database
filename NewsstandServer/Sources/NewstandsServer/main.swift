import Kitura
import LoggerAPI
import Application
import Kitura

do {

    let app = try App()
    try app.run()

} catch let error {
    Log.error(error.localizedDescription)
}

let router = Router()

router.get("/") { request, response, next in
    response.send("Hello world!")
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
