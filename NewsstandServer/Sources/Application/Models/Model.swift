//
//  File.swift
//  
//
//  Created by Qirui He on 2/26/20.
//

import Foundation
struct Book: Codable {
    let id: Int
    let title: String
    let price: Double
    let genre: String

    init(id: Int, title: String, price: Double, genre: String) {
        self.id = id
        self.title = title
        self.price = price
        self.genre = genre
    }
}

struct Auth: Codable {
let id: String
let password: String
    init(id: String, password: String) {
        self.id = id
        self.password = password
    }

}


