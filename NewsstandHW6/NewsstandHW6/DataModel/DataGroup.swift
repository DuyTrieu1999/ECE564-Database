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

    var createPerson:[DukePerson]!
    if(isAppAlreadylaunchedOnce())
    {
        createPerson=dataDecoder()
    }
    else
    {
        createPerson = downloadServer()
       // dataEncoder()
    }
    return createPerson
}

func downloadServer()->[DukePerson]
{
    var savePost = NSDictionary()
    var downloadPerson:[DukePerson]=[]
    var idList:[String]=[]
    let semaphore = DispatchSemaphore(value: 0)
    let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/preview")
            let httprequest = URLSession.shared.dataTask(with: url!){ (data, response, error) in
                if error != nil
                {
                    print("error calling in request all the persons!")
                }
                else
                {
                    do {
                        let post = try JSONSerialization.jsonObject(with: data!, options: []) as! [[String:AnyObject]]
                        for eachpost in post
                        {
                            savePost = eachpost as NSDictionary
                            print(savePost)
                            let netid = eachpost["id"] as! String
                            print(netid)
                            idList.append(netid)
                        }
                        semaphore.signal()
                    } catch let error {
                        print("json error: \(error)")
                    }
                }

            }
    httprequest.resume()
    semaphore.wait()
    for single_id in idList
    {
       downloadPerson.append(getPersonData(personid: single_id))
    }
    return downloadPerson
}

func stringtoRole(role:String) -> DukeRole
{
    if(role == "Student")
    {
        return DukeRole.Student
    }
    else if(role == "Professor")
    {
        return DukeRole.Professor
    }
    else if(role == "TA")
    {
        return DukeRole.TA
    }
    else
    {
        return DukeRole.Student
    }
}

func stringtoDegree(degree: String) ->DegreeType
{
    if(degree == "MS")
    {
        return DegreeType.MS
    }
    else if(degree == "PhD")
    {
        return DegreeType.PhD
    }
    else if(degree == "MEng")
    {
        return DegreeType.MEng
    }
    else if(degree == "BS")
    {
        return DegreeType.BS
    }
    else
    {
        return DegreeType.MS
    }
}

func stringtoGender(stringgender:String) -> Gender
{
    if(stringgender == "Male")
    {
        return Gender.Male
    }
    else
    {
        return Gender.Female
    }
}

func getPersonData(personid:String) -> DukePerson
{
    var newperson:DukePerson?
    let semaphore = DispatchSemaphore(value: 0)
    var saveperson=NSDictionary()
        let single_url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/b64entries/"+personid)
    _ = URLSession.shared.dataTask(with: single_url!){ (data, response, error) in
                    if error != nil
                    {
                        print("error calling in request all the persons!")
                    }
                    else
                    {
                        do {
                            let post = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                            saveperson = post as NSDictionary
//                            DispatchQueue.main.async {
                                let role=saveperson["role"] as! String
                                let team=saveperson["team"] as! String
                                let netid = saveperson["netid"] as! String
                                let lastname = saveperson["lastname"] as! String
                                let firstname = saveperson["firstname"] as! String
                                let wherefrom = saveperson["wherefrom"] as! String
                                let languages = saveperson["languages"] as! [String]
                                let id=saveperson["id"] as! String
                                let email=saveperson["email"] as! String
                                let hobbies=saveperson["hobbies"] as! [String]
                                let gender=saveperson["gender"] as! String
                                let department=saveperson["department"] as!String
                                
                                let image64=saveperson["picture"] as! String
                                let dataDecoded:Data=Data(base64Encoded: image64, options:.ignoreUnknownCharacters)!
             
                                let picture=UIImage(data:dataDecoded as Data)!
             
                            newperson = DukePerson(firstName: firstname, lastName: lastname, whereFrom: wherefrom, gender: stringtoGender(stringgender:gender), hobbies: hobbies, role: stringtoRole(role: role), degree: .BS, languages: languages, picture: picture, team: team, netid: netid, email: email, department: department, id: id, nextPage:"no", isFavourite: false)
                                semaphore.signal()
//                            }
                        } catch let error {
                            print("json error: \(error)")
                        }
                    }
    }.resume()
    semaphore.wait()
    return newperson!
}
func initializeDukePerson() -> [DukePerson] {
    // dukePerson entries
    let myself = DukePerson(firstName: "Yuqin", lastName: "Shen", whereFrom: "Guangdong, China", gender: .Female, hobbies: ["yogo", "reading", "Pili dramas"], role: .Student, degree: .MS, languages: ["C++", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "myself"), team: "Newsstand", netid: "ys238", email: "ys238@duke.edu", department: "Pratt School of Engineering", id: "ys238", nextPage: "Reading", isFavourite: false)
    let CongLi: DukePerson = DukePerson(firstName: "Cong", lastName: "Li", whereFrom: "Shanxi, China", gender: .Male, hobbies: ["traveling", "reading"], role: .Student, degree: .MS, languages: ["C++", "Java"], picture: UIImage(imageLiteralResourceName: "congli"), team: "Newsstand", netid: "cl518", email: "cl518@duke.edu", department: "Pratt School of Engineering", id: "cl518", nextPage: "Swimming", isFavourite: false)
    let QiruiHe: DukePerson = DukePerson(firstName: "Qirui", lastName: "He", whereFrom: "Guangxi, China", gender: .Male, hobbies: ["Basketball"], role: .Student, degree: .MS, languages: ["C++", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "qirui"), team: "Newsstand", netid: "qh37", email: "qh37@duke.edu", department: "Pratt School of Engineering", id: "qh37", nextPage: "Qirui", isFavourite: false)
    let TrieuDuy: DukePerson = DukePerson(firstName: "Trieu", lastName: "Duy", whereFrom: "Hanoi, Vietnam", gender: .Male, hobbies: ["traveling", "cooking", "coding"], role: .Student, degree: .BS, languages: ["JS", "Python", "Java"], picture: UIImage(imageLiteralResourceName: "duytrieu"), team: "Newsstand", netid: "dvt5", email: "dvt5@duke.edu", department: "Trinity School", id: "dvt5", nextPage: "world", isFavourite: false)
    let dukePersons: [DukePerson] = [myself, CongLi, QiruiHe, TrieuDuy]
    return dukePersons
}
var dukePersons:[DukePerson] = createDukePersons()
var sections: [GroupSection] = createSections(personArray: dukePersons)

func uploadnewperson(newperson: DukePerson)
{
    let username = "cl518"
       let password = "CB35F547EC349DA119EDFAE17566500E"
    let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)
    let base64LoginData = loginData!.base64EncodedString()
       // create the request
    let url=URL(string:"https://rt113-dt01.egr.duke.edu:5640/b64entries")
    guard let requesturl = url else {fatalError()}
    var request = URLRequest(url: requesturl)
    request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    request.setValue("application/json",forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let picImage = newperson.picture
    let picImageData: Data = picImage.jpegData(compressionQuality: 0.2)!
    let picBase64 = picImageData.base64EncodedString()
    let newdictionary: [String: Any] =
    [
    "id": newperson.id,
    "netid": newperson.netid,
    "firstname": newperson.firstName,
    "lastname": newperson.lastName,
    "wherefrom": newperson.whereFrom,
    "gender": newperson.gender.description(),
    "role": newperson.role.description(),
    "degree": newperson.degree.description(),
    "team": newperson.team ?? "1",
    "hobbies": newperson.hobbies,
    "languages": newperson.languages,
    "department": newperson.department,
    "email": newperson.email,
    "picture":picBase64
    ]
    let jsonData = try? JSONSerialization.data(withJSONObject: newdictionary,options: .fragmentsAllowed)
    request.httpBody = jsonData
    _ = URLSession.shared.dataTask(with: request){(data,response,error) in
        if (error != nil){
            print("Upload Failure")
            return
        }
        else
        {
            if let response = response as? HTTPURLResponse{
              print("Response HTTP Status code: \(response.statusCode)")
                print(newperson.firstName)
            }
    
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                          print("Response data string:\n \(dataString)")
                    }
        }
        
    }.resume()

}
//
//func tooglePost(person:DukePerson){
//    let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/entries")
//        guard let requestURL = url else { fatalError() }
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "POST"
//    let picImage = person.picture
//    let picImageData: Data = picImage.jpegData(compressionQuality: 0.2)!
//        let picBase64 = picImageData.base64EncodedString()
//    let postString = "id = \(String(describing: person.id))&netid = \(String(describing: person.netid))&firstname=\(String(describing: person.firstName))&lastname=\(String(describing: person.lastName))&wherefrom=\(String(describing: person.whereFrom))&gender=\(String(describing: person.gender.description()))&role=\(String(describing: person.role.description()))&degree=\(String(describing: person.degree.description()))&team=\(String(describing: person.team))&hobbies=\(String(describing: person.hobbies))&languages=\(String(describing: person.languages))&department=\(String(describing: person.department))&email=\(String(describing: person.email))&picture=\(String(describing: picBase64))"
//        request.httpBody = postString.data(using: String.Encoding.utf8)
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error took place \(error)")
//                return
//            }
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n \(dataString)")
//            }
//        }
//        task.resume()
//    }
//





