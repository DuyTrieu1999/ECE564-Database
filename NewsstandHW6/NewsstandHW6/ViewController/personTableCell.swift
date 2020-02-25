//
//  personTableCell.swift
//  ECE564_HOMEWORK
//
//  Created by student on 2/9/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class personTableCell: UITableViewCell {
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personSummary: UILabel!
    
    @IBOutlet weak var playImageView: UIImageView!
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        personImageView.layer.cornerRadius =  personImageView.layer.bounds.height / 2
        personImageView.clipsToBounds = true
        
        personSummary.lineBreakMode = .byWordWrapping
        personSummary.numberOfLines = 0
       }
    
    func setPerson(person: DukePerson) {
        personImageView.image = person.picture
        personName.text = person.firstName + " " + person.lastName
        let found: ([String], [DukePerson]) = searchByName(names: [person.firstName, person.lastName])
        let description:String = found.0[0]
        let person_found:DukePerson = found.1[0]
        if person_found.nextPage == "no" {
            playImageView.isHidden = true
        }
        else {
            playImageView.isHidden = false
        }
        personSummary.text = description
       }
}
