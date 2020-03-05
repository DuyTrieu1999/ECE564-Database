//
// DukePersonBase64Entry.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


public struct DukePersonBase64Entry: Codable {


    public var _id: String?

    public var netid: String

    public var firstname: String

    public var lastname: String

    public var wherefrom: String

    public var gender: String

    public var role: String

    public var degree: String

    public var team: String

    public var hobbies: [String]

    public var languages: [String]

    public var department: String

    public var email: String

    public var picture: String?
    public init(_id: String? = nil, netid: String, firstname: String, lastname: String, wherefrom: String, gender: String, role: String, degree: String, team: String, hobbies: [String], languages: [String], department: String, email: String, picture: String? = nil) { 
        self._id = _id
        self.netid = netid
        self.firstname = firstname
        self.lastname = lastname
        self.wherefrom = wherefrom
        self.gender = gender
        self.role = role
        self.degree = degree
        self.team = team
        self.hobbies = hobbies
        self.languages = languages
        self.department = department
        self.email = email
        self.picture = picture
    }
    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case netid
        case firstname
        case lastname
        case wherefrom
        case gender
        case role
        case degree
        case team
        case hobbies
        case languages
        case department
        case email
        case picture
    }

}
