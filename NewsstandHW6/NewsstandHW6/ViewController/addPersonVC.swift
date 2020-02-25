//
//  addPersonVC.swift
//  ECE564_HOMEWORK
//
//  Created by student on 2/12/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class addPersonVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

// Labels
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var hobbiesLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    
    // TextFields
  
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var genderField: UITextField!

    @IBOutlet weak var roleField: UITextField!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var degreeField: UITextField!
    @IBOutlet weak var hobbiesField: UITextField!
    @IBOutlet weak var languagesField: UITextField!
    @IBOutlet weak var teamField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    // Tool bar
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    // ImageView
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet var imageTap: UITapGestureRecognizer!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    // Home button
    @IBOutlet weak var btnHome: UIButton!
    
    var textFields: [UITextField]!
    var person: DukePerson?
    var addPage: Bool?
    var editTextFieldToggle: Bool = true
    var isEditMode = true
    var teamList = ["","Reality Kit", "UI Builder", "WizeView", "First Year", "Reflux", "HFTP", "Newsstand", "Student", "Professor"]
    var degreeList = ["MS", "MEng", "BA", "BS", "PhD", "MBA"]
    var roleList = ["Student", "TA",  "Professor"]
    var genderList = ["Male", "Female"]
    var teamPicker = UIPickerView()
    var degreePicker = UIPickerView()
    var rolePicker = UIPickerView()
    var genderPicker = UIPickerView()
    var imagePickerController = UIImagePickerController()
    let twitterBlue: UIColor = UIColor(red: 29.0/255.0, green: 161.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        imagePickerController.delegate = self
        textFields = [firstNameField, lastNameField, roleField, genderField, fromField, degreeField, hobbiesField, languagesField, teamField]
        setEditing(isEditMode, animated: true)
        loadPickers()
        setUI(edit: editTextFieldToggle)
    }
    
    func loadPickers() {
           teamPicker.delegate = self
           teamPicker.dataSource = self
           degreePicker.delegate = self
           degreePicker.dataSource = self
           rolePicker.delegate = self
           rolePicker.dataSource = self
           genderPicker.delegate = self
           genderPicker.dataSource = self
           teamPicker.tag = 0
           degreePicker.tag = 1
           rolePicker.tag = 2
           genderPicker.tag = 3
           teamField.inputView = teamPicker
           degreeField.inputView = degreePicker
           roleField.inputView = rolePicker
           genderField.inputView = genderPicker
       }
    
    private func setButton() {
        btnHome.layer.cornerRadius = btnHome.layer.bounds.height / 2
        btnHome.clipsToBounds = true
        btnHome.backgroundColor = twitterBlue
        btnEdit.target = self
        btnEdit.action = #selector(toogleEditor)
        btnEdit.title = "Save"
        btnCancel.target = self
        btnCancel.action = #selector(toogleCancel)
        cameraImageView.tintColor = twitterBlue
    }
    
    // Set User Interface
    func setUI(edit: Bool){
       if edit {
            textFieldActive()
        }
        else {
            textFieldDeactive()
        }
        setButton()
        if person != nil {
            personImageView.image = person?.picture.circleMask
        }
        else {
            personImageView.image = UIImage(imageLiteralResourceName: "logo").circleMask
        }
    }
    
    // MARK: - Team picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == teamPicker {
            return teamList.count
        }
        else if pickerView == degreePicker {
            return degreeList.count
        }
        else if pickerView == rolePicker {
            return roleList.count
        }
        else {
            return genderList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == teamPicker {
             return teamList[row]
        }
        else if pickerView == degreePicker {
            return degreeList[row]
        }
        else if pickerView == rolePicker {
            return roleList[row]
        }
        else {
            return genderList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == teamPicker {
            teamField.text = teamList[row]
            self.view.endEditing(false)
        }
        else if pickerView == degreePicker {
            degreeField.text = degreeList[row]
            self.view.endEditing(false)
        }
        else if pickerView == rolePicker {
            roleField.text = roleList[row]
            self.view.endEditing(false)
        }
        else {
            genderField.text = genderList[row]
            self.view.endEditing(false)
        }
    }
    
    
    // MARK: - ImagePicker
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
             dismiss(animated: true, completion: nil)
         }
         
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        personImageView.image = selectedImage.circleMask
         dismiss(animated: true, completion: nil)
     }
    
    // MARK: - Photo from Camera
    @IBOutlet var takePhotoTap: UITapGestureRecognizer!
    
    @IBAction func takePhotoFromCamera(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
             imagePickerController.sourceType = .camera
             imagePickerController.allowsEditing = true
             present(imagePickerController, animated: true, completion: nil)
        }
        else {
            createAlert(title: "WARNING!", message: "You don't have a camera!")
        }
    }
    
    /// Cancel toogler
    @objc func toogleCancel(sender: UIButton){
        if addPage ?? false {
            clearInput()
        }
        else {
            isEditMode = false
            btnEdit.title = "Edit"
            textFieldDeactive()
        }
    }
    
    /// Edit / Save toogler
    @objc func toogleEditor(sender: UIButton){
        if isEditMode {
            if(addUpdateAction()) {
                isEditMode = false
                btnEdit.title = "Edit"
                textFieldDeactive()
            }
        }
        else {
            isEditMode = true
            btnEdit.title = "Save"
            textFieldActive()
        }
        setEditing(isEditMode, animated: true)
    }
    
    /// activate textfield
    func textFieldActive() {
        for field in textFields {
            field.isEnabled = true
        }
        imageTap.isEnabled = true
        takePhotoTap.isEnabled = true
    }
    
    /// deactivate textfield
    func textFieldDeactive() {
        for field in textFields {
            field.isEnabled = false
        }
        imageTap.isEnabled = false
        takePhotoTap.isEnabled = false
    }

    
    /// ADD / UPDATE function
    func addUpdateAction() -> Bool
    {
        let firstName: String = firstNameField.text!
        let lastName: String = lastNameField.text!
        if firstName.isEmpty || lastName.isEmpty {
            print(firstName + "aha")
            createAlert(title: "WARNING", message: "Please fill all blanks!")
            return false
        }
        var gender: Gender = .Male
        if genderField.text == "Male" {
            gender = .Male
        } else if genderField.text == "Female" {
            gender = .Female
        } else {
            createAlert(title: "WARNING!", message: "gender must be Male or Female")
            return false
        }
        var role: DukeRole = .Student
        if roleField.text == "Student" {
            role = .Student
        } else if roleField.text == "TA" {
            role = .TA
        } else if roleField.text == "Professor" {
            role = .Professor
        } else {
            createAlert(title: "WARNING!", message: "role must be Student, TA or Professor")
            return false
        }
        let from: String = fromField.text!
          if from.isEmpty {
              createAlert(title: "WARNING", message: "Please fill all blanks!")
            return false
          }
        var degree: DegreeType = .MS
        if degreeField.text == "MS" {
            degree = .MS
        } else if degreeField.text == "MEng" {
            degree = .MEng
        } else if degreeField.text == "BA" {
            degree = .BA
        } else if degreeField.text == "BS" {
            degree = .BS
        } else if degreeField.text == "MBA" {
            degree = .MBA
        } else if degreeField.text == "PhD" {
            degree = .PhD
        } else {
            createAlert(title: "WARNING!", message: "Degree must be MS, MEng, BA, BS, PhD or MBA")
            return false
        }
        let hobbies: [String] = getArray(input: hobbiesField.text!)
        if hobbies.count > 3 {
            createAlert(title: "WARNING!", message: "Up to three hobbies!")
            return false
        }
        let languages: [String] = getArray(input: languagesField.text!)
        if languages.count > 3 {
            createAlert(title: "WARNING", message: "Up to three languages!")
            return false
        }
        if hobbiesField.text!.isEmpty || languagesField.text!.isEmpty {
            createAlert(title: "WARNING", message: "Please fill all blanks!")
            return false
        }
        var team: String = teamField.text!
        if team.isEmpty {
            team = roleField.text!
        }
        
        // if person exists, update information
        for dukeperson in dukePersons {
            if dukeperson.firstName == firstName && dukeperson.lastName == lastName {
                dukeperson.whereFrom = from
                dukeperson.gender = gender
                dukeperson.hobbies = hobbies
                dukeperson.role = role
                dukeperson.degree = degree
                dukeperson.languages = languages
                dukeperson.team = team
                dukeperson.picture = personImageView.image ?? UIImage(imageLiteralResourceName: "logo")
                sections = updateSections()
                createAlert(title: "DONE!", message: "\(firstName) \(lastName) is found! Personal Information has beed updated.")
                return true
            }
        }
        let newPerson: DukePerson = DukePerson(firstName: firstName, lastName: lastName, whereFrom: from, gender: gender, hobbies: hobbies, role: role, degree: degree , languages: languages, picture: personImageView.image ?? UIImage(imageLiteralResourceName: "logo"), team: team, netid: "", email: "", department: "", id: "", nextPage: "no")
        
        dukePersons.append(newPerson)
        sections = updateSections()
        createAlert(title: "DONE!", message: "\(firstName) \(lastName) has been added!")
        clearInput()
        return true
    }
    
    // return array of string
    private func getArray(input: String)->[String]{
        let split = input.components(separatedBy: [","])
        let array: [String] = Array(split)
        return array
     }
    
    // clear all fields
    private func clearInput() {
        for field in textFields {
            field.text!.removeAll()
        }
        personImageView.image = UIImage(imageLiteralResourceName: "logo")
    }
    
    
    // pop-up alert
    private func createAlert(title: String, message: String){
        textFieldActive()
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
}

extension UIImage {
    var circleMask: UIImage {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}


// format printing string array
private func printArray(strs: Array<String>) -> String {
    var ans = ""
    for i in 0..<strs.count {
        if i != strs.count - 1 {
            ans += strs[i] + ", "
        }
        else {
            ans += strs[i]
        }
    }
    return ans
}
