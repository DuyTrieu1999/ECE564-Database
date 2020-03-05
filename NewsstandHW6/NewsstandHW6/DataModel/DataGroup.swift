//
//  DataGroup.swift
//  ECE564_HOMEWORK
//
//  Created by student on 2/9/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import Foundation
import UIKit

struct GroupSection {
    var team: String
    var personList: [DukePerson]
}

let jsonPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("persons.plist")

// encode data, save to jsonPath
func dataEncoder() {
    let encodeData = try? JSONEncoder().encode(dukePersons)
    do {
        try encodeData!.write(to: jsonPath!)
    }
    catch {
        print("Failed to write JSON data: \(error.localizedDescription)")
    }
}

// decode data from jsonPath
func dataDecoder() -> [DukePerson] {
    if let decodeData = try? Data(contentsOf: jsonPath!){
        do {
            let personArray = try JSONDecoder().decode([DukePerson].self, from: decodeData)
            return personArray
        }
        catch {
            print(error.localizedDescription)
        }
    }

    return []
}

func createSections(personArray: [DukePerson]) -> [GroupSection] {
    var groups: [String : [DukePerson]] = [:]
    for person in personArray {
        var exitItem = groups[person.team ?? person.role.description()] ?? [DukePerson]()
        exitItem.append(person)
        groups[person.team ?? person.role.description()] = exitItem
    }
    var sections:[GroupSection] = []
    for (key, values) in groups {
        let section = GroupSection(team: key, personList: values)
        if key == "Newsstand" {
            sections.insert(section, at: 0)
        }
        else {
            sections.append(section)
        }
    }
    return sections
}

func isAppAlreadylaunchedOnce() -> Bool {
    let defaults = UserDefaults.standard
    if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
        print("App already launched")
        return true
    }
    else{
        defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        print("App first launched")
        return false
    }
}

func createDukePersons() -> [DukePerson]{
    let dukePersons:[DukePerson]!
       if isAppAlreadylaunchedOnce() {
           dukePersons = dataDecoder()
       }
       else{
           dukePersons = initializeDukePerson()
           dataEncoder()
       }
       return dukePersons
}

func initializeDukePerson() -> [DukePerson] {
    // dukePerson entries
    let myself = DukePerson(firstName: "Yuqin", lastName: "Shen", whereFrom: "Guangdong, China", gender: .Female, hobbies: ["yogo", "reading", "Pili dramas"], role: .Student, degree: .MS, languages: ["C++", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "myself"), team: "Newsstand", netid: "ys238", email: "ys238@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "Reading", isFavourite: false)
    let professor =  DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County, NC", gender: .Male, hobbies: ["swimming", "biking", "hiking"], role: .Professor, degree: .BS, languages: ["Swift", "C", "C++"], picture: UIImage(imageLiteralResourceName: "Ric"), team: "Professor", netid: "rt113", email: "rt113@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "no", isFavourite: false)
    let TA1 = DukePerson(firstName: "Jingru", lastName: "Gao", whereFrom: "Shanghai, China", gender: .Female, hobbies: ["traveling", "reading", "movies"], role: .TA, degree: .MS, languages: ["Swift", "C++", "Python"], picture: UIImage(imageLiteralResourceName: "Jingru"), team: "TA", netid: "jg404", email: "jg404@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "no", isFavourite: false)
    let TA2 = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "Hebei, China", gender: .Male, hobbies: ["reading", "jogging"], role: .Student, degree: .MS, languages: ["Swift", "Python"], picture: UIImage(imageLiteralResourceName: "haohong"), team: "TA", netid: "hz147", email: "hz147@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "no", isFavourite: false)

    // add more two persons

    let CongLi: DukePerson = DukePerson(firstName: "Cong", lastName: "Li", whereFrom: "Shanxi, China", gender: .Male, hobbies: ["traveling", "reading"], role: .Student, degree: .MS, languages: ["C++", "Java"], picture: UIImage(imageLiteralResourceName: "congli"), team: "Newsstand", netid: "ym132", email: "ym132@duke.edu", department: "Pratt School of Engineering", id: "", nextPage: "Swimming", isFavourite: false)
    let QiruiHe: DukePerson = DukePerson(firstName: "Qirui", lastName: "He", whereFrom: "Guangxi, China", gender: .Male, hobbies: ["Basketball"], role: .Student, degree: .MS, languages: ["C++", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "qirui"), team: "Newsstand", netid: "qh37", email: "qh37@duke.edu", department: "Pratt School of Engineering", id: "qh37", nextPage: "Qirui", isFavourite: false)
    let TrieuDuy: DukePerson = DukePerson(firstName: "Trieu", lastName: "Duy", whereFrom: "Hanoi, Vietnam", gender: .Male, hobbies: ["traveling", "cooking", "coding"], role: .Student, degree: .BS, languages: ["JS", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "duytrieu"), team: "Newsstand", netid: "dvt5", email: "dvt5@duke.edu", department: "Trinity School", id: "", nextPage: "world", isFavourite: false)
    let dukePersons: [DukePerson] = [myself, professor, TA1, TA2, CongLi, QiruiHe, TrieuDuy]
    return dukePersons
}

var dukePersons:[DukePerson] = createDukePersons()
var sections: [GroupSection] = createSections(personArray: dukePersons)








