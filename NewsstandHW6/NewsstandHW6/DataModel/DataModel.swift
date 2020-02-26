//
//  DataModel.swift
//  ECE564_HOMEWORK
//
//  Created by student on 1/28/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import Foundation
/*:
 ### ECE 564 HW1 assignment - Please see Sakai Assignment "HW1" for detailed instructions on what is expected in this Assignment.
 In this first assignment, you are going to create a base data model for storing information about the Students, TAs and Professor in ECE 564. You need to populate your data model with at least 4 records (you, the Professor, 2 TAs), but can add more.  You will also provide a search function ("find") to search an array of those objects.
 */
enum Gender: String, Codable {
    case Male
    case Female
    func description() -> String {
        switch self {
        case .Male:
            return "Male"
        case .Female:
            return "Female"
        }
    }
}

class Person: Codable {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
    var nextPage: String = "no"
    
    private enum CodingKeys: String, CodingKey{
        case firstName, lastName, whereFrom, gender, nextPage
    }

    init(firstName: String, lastName: String, whereFrom: String, gender: Gender, nextPage: String){
           self.firstName = firstName
           self.lastName = lastName
           self.whereFrom = whereFrom
           self.gender = gender
           self.nextPage = nextPage
           
       }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        whereFrom = try container.decode(String.self, forKey: .whereFrom)
        gender = try container.decode(Gender.self, forKey: .gender)
        nextPage = try container.decode(String.self, forKey: .nextPage)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey:.lastName)
        try container.encode(whereFrom, forKey: .whereFrom)
        try container.encode(gender, forKey:.gender)
        try container.encode(nextPage, forKey: .nextPage)
    }
}

enum DukeRole : String, Codable {
    case Student, Professor, TA
    func description() -> String {
        switch self {
        case .Student:
            return "Student"
        case .Professor:
            return "Professor"
        case .TA:
            return "TA"
        }
    }
}

protocol ECE564 {
    var hobbies : [String] { get }
    var role : DukeRole { get }
    var degree : DegreeType {get}
    var languages : [String] {get}
    var picture: UIImage {get}  // we will use in future HW
    var team: String? {get} // we will use in future HW
    var netid: String? {get} // we will use in future HW
    var email: String {get} // we will use in future HW
    var department: String? {get} // we will use in future HW
    var id: String? {get} // we will use in future HW
}

extension ECE564 {
    var team: String? {return nil}
    var netid: String? {return nil}
    var department: String? {return nil}
    var id: String? {return nil}
}

//: ### START OF HOMEWORK
//: Do not change anything above.
//: Put your code here:

enum DegreeType : String, Codable {
    case MS  , MEng, BA, BS, PhD, MBA
    func description() -> String {
        switch self {
        case .MS:
            return "MS"
        case .MEng:
            return "MEng"
        case .BA:
            return "BA"
        case .BS:
            return "BS"
        case .PhD:
            return "PhD"
        case .MBA:
            return "MBA"
        }
    }
}
// DukePerson class whilch is a sub-class of the Person class and
// support the ECE564 and CustomStringConvertible protocols
class DukePerson: Person, ECE564, CustomStringConvertible {
    
    var hobbies : [String]
    var role : DukeRole
    var degree : DegreeType
    var languages : [String]
    var picture: UIImage  // we will use in future HW
    var team: String? // we will use in future HW
    var netid: String // we will use in future HW
    var email: String  // we will use in future HW
    var department: String // we will use in future HW
    var id: String
    
    private enum CodingKeys: String, CodingKey { case hobbies, role, degree, languages, picture, team, netid, email, department, id }
    
    init (firstName: String, lastName: String, whereFrom: String, gender: Gender, hobbies: [String], role: DukeRole, degree: DegreeType, languages: [String], picture: UIImage, team: String, netid: String, email: String, department: String, id: String, nextPage: String) {
        self.hobbies = hobbies
        self.role = role
        self.degree = degree
        self.languages = languages
        self.picture = picture
        self.team = team
        self.netid = netid
        self.email = email
        self.department = department
        self.id = id
        super.init(firstName: firstName, lastName: lastName, whereFrom: whereFrom, gender: gender, nextPage: nextPage)
     
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let superdecoder = try container.superDecoder()
        hobbies = try container.decode([String].self, forKey: .hobbies)
        role = try container.decode(DukeRole.self, forKey: .role)
        degree = try container.decode(DegreeType.self, forKey: .degree)
        languages = try container.decode([String].self, forKey: .languages)
        let text = try container.decodeIfPresent(String.self, forKey: .picture)
        let data = Data(base64Encoded: text!)
        picture = UIImage(data: data!)!
        team = try container.decode(String.self, forKey: .team)
        netid = try container.decode(String.self, forKey: .netid)
        email = try container.decode(String.self, forKey: .email)
        department = try container.decode(String.self, forKey: .department)
        id = try container.decode(String.self, forKey: .id)
        try super.init(from: superdecoder)
    }

    override func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hobbies, forKey: .hobbies)
        try container.encode(role, forKey: .role)
        try container.encode(degree, forKey: .degree)
        try container.encode(languages, forKey: .languages)
        try container.encode(team, forKey: .team)
        try container.encode(netid, forKey: .netid)
        try container.encode(email, forKey: .email)
        try container.encode(department, forKey: .department)
        try container.encode(id, forKey: .id)
        let superencoder = container.superEncoder()
        let data = picture.jpegData(compressionQuality: 0.2)
        try container.encode(data, forKey: .picture)

        try super.encode(to: superencoder)

    }
    
    
    
    // pronounce() takes no input, but return pair of strings according to gender
    func pronounce() -> (String, String) {
        if gender == .Male {
            return ("He", "his")
        }
        return ("She", "her")
    }
    // printMajor() takes no input, but return a string which print majors
    // according class role property
    func printMajor() -> String {
        return "\(pronounce().0) has achieved \(degree) degree."
    }
    // print Array func takes Array<String> as input, and returns a string while formats array printing
    func printArray(strs: Array<String>) -> String {
        var ans = ""
        if strs.isEmpty {
            return "nothing"
        }
        for i in 0..<strs.count {
            if i != strs.count - 1 {
                ans += strs[i] + ", "
            }
            else {
                ans += "and " + strs[i]
            }
        }
        return ans
    }
    // overload CustomStringConvertible description, which returns a string to print the person information
    var description: String {
        let summary = "\(firstName) \(lastName) comes from \(whereFrom) and is a \(role) in Duke University. \(printMajor())\(pronounce().0) is proficient in \(printArray(strs: languages)). When not in class, \(firstName) enjoys \(printArray(strs: hobbies)).\n"

        return summary
    }
}
// dukePerson entries
let myself = DukePerson(firstName: "Yuqin", lastName: "Shen", whereFrom: "Guangdong, China", gender: .Female, hobbies: ["yogo", "reading", "Pili dramas"], role: .Student, degree: .MS, languages: ["C++", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "myself"), team: "Newsstand", netid: "ys238", email: "ys238@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "Reading")
let professor =  DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County, NC", gender: .Male, hobbies: ["swimming", "biking", "hiking"], role: .Professor, degree: .BS, languages: ["Swift", "C", "C++"], picture: UIImage(imageLiteralResourceName: "Ric"), team: "Professor", netid: "rt113", email: "rt113@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "no")
let TA1 = DukePerson(firstName: "Jingru", lastName: "Gao", whereFrom: "Shanghai, China", gender: .Female, hobbies: ["traveling", "reading", "movies"], role: .TA, degree: .MS, languages: ["Swift", "C++", "Python"], picture: UIImage(imageLiteralResourceName: "Jingru"), team: "TA", netid: "jg404", email: "jg404@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "no")
let TA2 = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "Hebei, China", gender: .Male, hobbies: ["reading", "jogging"], role: .Student, degree: .MS, languages: ["Swift", "Python"], picture: UIImage(imageLiteralResourceName: "haohong"), team: "TA", netid: "hz147", email: "hz147@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "no")

// add more two persons

let CongLi: DukePerson = DukePerson(firstName: "Cong", lastName: "Li", whereFrom: "Shanxi, China", gender: .Male, hobbies: ["traveling", "reading"], role: .Student, degree: .MS, languages: ["C++", "Java"], picture: UIImage(imageLiteralResourceName: "congli"), team: "Newsstand", netid: "ym132", email: "ym132@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "Swimming")
let QiruiHe: DukePerson = DukePerson(firstName: "Qirui", lastName: "He", whereFrom: "Guangxi, China", gender: .Male, hobbies: ["Basketball"], role: .Student, degree: .MS, languages: ["C++", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "qirui"), team: "Newsstand", netid: "qh37", email: "qh37@duke.edu", department: "Pratt School of Engineering", id: "qh37", nextPage: "Qirui")
let TrieuDuy: DukePerson = DukePerson(firstName: "Trieu", lastName: "Duy", whereFrom: "Hanoi, Vietnam", gender: .Male, hobbies: ["traveling", "cooking", "coding"], role: .Student, degree: .BS, languages: ["JS", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "duytrieu"), team: "Newsstand", netid: "dvt5", email: "dvt5@duke.edu", department: "Trinity School", id: "", nextPage: "world")
var dukePersons: [DukePerson] = [myself, professor, TA1, TA2, CongLi, QiruiHe, TrieuDuy]


// searchByName takes an array of name string as input, and returns a string, if
// no person found whould print nameerror, otherwise return the description
func searchByName(names: Array<String>) -> ([String], [DukePerson]) {
  var found: [String] = []
  var persons: [DukePerson] = []
  var cnt = 0
  let nameError = "No such person with this name!"
  if names.count > 2 {
    return ([nameError], [])
  }
  if names.count == 2 {
     for person in dukePersons {
      if person.firstName == names[0] && person.lastName == names[1]{
        found.append(person.description)
        persons.append(person)
        cnt += 1
      }
    }
  }
  else {
    for person in dukePersons {
      if names.contains(person.firstName) || names.contains(person.lastName) {
        found.append(person.description)
        persons.append(person)
        cnt += 1
      }
    }
  }
 return found.isEmpty ? ([nameError], persons) : (found, persons)
}

// searchByNetid takes an array of netid string as input, and returns a string, if
// no person found whould print netiderror, otherwise return the description of one or more found persons
func searchByNetid(netids: Array<String>) -> String {
  var found = ""
  var cnt = 0
  let netidError = "No such person with this netID!"
  for person in dukePersons {
    if netids.contains(person.netid) {
      found += person.description
      cnt += 1
    }
  }
  return found.isEmpty ? netidError : ("\(cnt) person(s) found by searching netID!\n" + found)
}

func searchByNetID(netid: String) -> DukePerson? {
    for person in dukePersons {
        if person.netid == netid {
            return person
        }
    }
    return nil
}
// searchByNetid takes an array of place string as input, and returns a string, if
// no person found whould print placeerror, otherwise return the description of one or more found persons
func searchByWhere(places: Array<String>) -> String {
  var found = ""
  var cnt = 0
  let placeError = "No such person from this place!"
  for place in places {
    for person in dukePersons {
      let subplace = person.whereFrom.components(separatedBy:[" ", ","])
      if subplace.contains(place) {
        found += person.description
        cnt += 1
      }
    }
  }
  return found.isEmpty ? placeError : ("\(cnt) person(s) found by searching places!\n" + found)
}
// searchByNetid takes an array of place string as input, and returns a string, if
// no person found whould print languageserror, otherwise return the description of one or more found persons
func searchByLanguage(languages: Array<String>) -> String {
  var found = ""
  var cnt = 0
  let languageError = "No such person found by searching languages!"
  for person in dukePersons {
    var dict:[String] = []
    for word in person.languages {
      dict.append(word.lowercased())
    }
    for language in languages {
      if dict.contains(language.lowercased()) {
        found += person.description
        cnt += 1
        break
      }
    }
  }
  return found.isEmpty ? languageError : ("\(cnt) person(s) found by searching languages!\n" + found)
}
// find func takes a string as input, and returns a string, it calls the above four searching funcs
// based on the give /n, /netid, /w, or /l, if succeed returns persons description, if not, will cause typeError
func find(_ parmString: String) -> String {
  let typeError = "Please enter \"/n  firstName or lastName\" or \"/w place\" or \"/netid netID\" or \"/l languages\""
  if parmString.isEmpty {
    return typeError
  }
  let command = parmString.components(separatedBy: " ")
  let count = command.count
  let searchKey = command[0]
  let key = ["/n", "/w", "/netid", "/l"]
  if !key.contains(searchKey) || count <= 1 {
    return typeError
  }
  let searchValue = command[1 ..< count] // [9, 10]
  let searchValArr: [String] = Array(searchValue)
  if searchKey == "/n" {
    return searchByName(names: searchValArr).0[0]
  }
  if searchKey == "/w" {
    return searchByWhere(places: searchValArr)
  }
  if searchKey == "/netid" {
    return searchByNetid(netids: searchValArr)
  }
  return searchByLanguage(languages: searchValArr)
}


