//
//  File.swift
//  
//
//  Created by Qirui He on 2/26/20.
//

import Foundation
import KituraContracts

func initializeCodableRoutes(app: App) {
    // Register routes here
    app.router.post("/codable", handler: app.postHandler)
    app.router.get("/codable", handler: app.getAllHandler)
    app.router.get("/codable", handler: app.getOneHandler)
    
    app.router.post("/auth", handler: app.postAuthHandler)
    app.router.get("/auth", handler: app.getAllAuthHandler)
    app.router.get("/auth", handler: app.getOneAuthHandler)
}
extension App {
    static var codableStore = [Book]()
    static var auths = [Auth]()
    // Write handlers here
    func postHandler(book: Book, completion: (Book?, RequestError?) -> Void) {
        App.codableStore.append(book)
        completion(book, nil)
    }
    func getAllHandler(completion: ([Book]?, RequestError?) -> Void) {
        completion(App.codableStore, nil)
    }
    func getOneHandler(id: Int, completion: (Book?, RequestError?) -> Void) {
        guard id < App.codableStore.count, id >= 0 else {
            return completion(nil, .notFound)
        }
        completion(App.codableStore[id], nil)
    }
    
    func postAuthHandler(auth: Auth, completion: (Auth?, RequestError?) -> Void) {
        App.auths.append(auth)
        completion(auth, nil)
    }
    func getAllAuthHandler(completion: ([Auth]?, RequestError?) -> Void) {
        completion(App.auths, nil)
    }
    func findAuth(id: String) -> Auth? {
        for auth in App.auths {
            if auth.id == id {
                return auth
            }
        }
        return nil
    }
    func getOneAuthHandler(id: String, completion: (Auth?, RequestError?) -> Void) {
//        let temp: Auth ?? nil
//        for auth in App.auths {
//            if auth.id == id {
//                temp = auth
//                break
//            }
//        }
        guard let temp = findAuth(id: id)  else {
            return completion(nil, .notFound)
        }
        completion(temp, nil)
    }
}
