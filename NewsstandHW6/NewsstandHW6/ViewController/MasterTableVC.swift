//
//  MasterTableVC.swift
//  ECE564_HOMEWORK
//
//  Created by student on 2/9/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit



class MasterTableVC: UITableViewController {

  
    @IBOutlet weak var barSearch: UISearchBar!
    var searchDukePerson: [DukePerson]!
    var searchSections:[GroupSection]!
    var searching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag
        setSearchbar()
    }
    func setSearchbar() {
        barSearch.tintColor = UIColor(red: 29.0/255.0, green: 161.0/255.0, blue: 242.0/255.0, alpha: 1.0)
       let textFieldInsideUISearchBar = barSearch.value(forKey: "searchField") as? UITextField
        let placeholderLabel = textFieldInsideUISearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font = UIFont(name: "Avenir Next", size: 16)
        textFieldInsideUISearchBar?.font = UIFont(name: "Avenir Next", size: 16)
    }

   // Segue setup
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "MasterToDetail" {
            let destCV = segue.destination as! PageVC
            destCV.person = sender as? DukePerson
            destCV.addPage = false
        }
        if segue.identifier == "addPerson" {
            let destCV = segue.destination as! addPersonVC
            destCV.person = sender as? DukePerson
            destCV.addPage = true
            destCV.editTextFieldToggle = true
        }
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searching {return searchSections?.count ?? 0}
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            let section = searchSections?[section]
            return section?.personList.count ?? 0
        }
        let section = sections[section]
        return section.personList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell") as! personTableCell
        if searching {
            let searchInstance = searchSections[indexPath.section].personList[indexPath.row]
            cell.setPerson(person: searchInstance)
        }
        else{
            let instance = sections[indexPath.section].personList[indexPath.row]
            cell.setPerson(person: instance)
        }
        return cell
        }
    
    // didSelectRow event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            let instance = searchSections[indexPath.section].personList[indexPath.row]
            performSegue(withIdentifier: "MasterToDetail", sender: instance)
        }
        else {
            let instance = sections[indexPath.section].personList[indexPath.row]
            performSegue(withIdentifier: "MasterToDetail", sender: instance)
        }
      }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        // twitter blue
        view.backgroundColor = UIColor(red: 29.0/255.0, green: 161.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        if searching {
            label.text = searchSections[section].team + ": " +
            String(searchSections[section].personList.count)
        } else {
            label.text = sections[section].team + ": " +
            String(sections[section].personList.count)
        }
        
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if searching {
                let personDelete: DukePerson = searchSections[indexPath.section].personList[indexPath.row]
                if let index = dukePersons.firstIndex(where: {
                    $0.firstName == personDelete.firstName && $0.lastName == personDelete.lastName
                }) {
                    dukePersons.remove(at: index)
                }
                searchSections[indexPath.section].personList.remove(at:indexPath.row)

            }
            else {
                let personDelete: DukePerson = sections[indexPath.section].personList[indexPath.row]
                if let index = dukePersons.firstIndex(where: {
                    $0.firstName == personDelete.firstName && $0.lastName == personDelete.lastName
                }) {
                    dukePersons.remove(at: index)
                }
                sections[indexPath.section].personList.remove(at:indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            sections = updateSections()
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sections = updateSections()
        self.tableView.reloadData()
    }
    
    // segue back to home function
     @IBAction func unwindToHome(_ sender: UIStoryboardSegue){
        sections = updateSections()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension MasterTableVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchValue = searchText.components(separatedBy: [" ",","])
        let searchValArr: [String] = Array(searchValue)
        let found: ([String], [DukePerson]) = searchByName(names: searchValArr)
        searchDukePerson = found.1
        if let found_Netid = searchByNetID(netid: searchText) {
            searchDukePerson.append(found_Netid)
        }
        searchSections = createSections(personArray: searchDukePerson ?? [])
        searching = true
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
