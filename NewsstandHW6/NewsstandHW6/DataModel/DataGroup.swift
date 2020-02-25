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

// encode data,  then decode data to DukePerson objects then create sessions, make my team as first appears section
func updateSections() -> [GroupSection] {
    dataEncoder()
    let personArray: [DukePerson] = dataDecoder()
    return createSections(personArray: personArray)
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


var sections: [GroupSection] = updateSections()








