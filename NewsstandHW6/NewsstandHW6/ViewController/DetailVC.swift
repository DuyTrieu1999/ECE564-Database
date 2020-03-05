//
//  DetailVC.swift
//  ECE564_HOMEWORK
//
//  Created by student on 2/10/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
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
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var genderField: UITextField!

    @IBOutlet weak var roleField: UITextField!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var degreeField: UITextField!
    @IBOutlet weak var hobbiesField: UITextField!
    @IBOutlet weak var languagesField: UITextField!
    @IBOutlet weak var teamField: UITextField!
  
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var cameraImageView: UIImageView!
    // ImageView
    @IBOutlet weak var personImageView: UIImageView!
    
    // Buttons
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    
    var person: DukePerson?
    var addPage: Bool!
    var editTextFieldToggle: Bool!
    var isEditMode:Bool!
    var textFields: [UITextField]!
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
        loadPickers()
        textFields = [firstNameField, lastNameField, roleField, genderField, fromField, degreeField, hobbiesField, languagesField, teamField, emailField]
        setEditing(isEditMode, animated: true)
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
   
    @IBOutlet var imageTap: UITapGestureRecognizer!
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
       personImageView.image = selectedImage
       dismiss(animated: true, completion: nil)
   }
    
    // MARK: - Photo from Camera
    @IBOutlet var takePhotoTap: UITapGestureRecognizer!
    
    @IBAction func takePhoto(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
             imagePickerController.sourceType = .camera
             imagePickerController.allowsEditing = true
             present(imagePickerController, animated: true, completion: nil)
        }
        else {
            createAlert(title: "WARNING!", message: "You don't have a camera!")
        }
    }
    
    /// set button UI
    func setButton(){
        if person?.netid == currNetID {
             btnCancel.isHidden = false
             btnEdit.isHidden = false
             btnPost.isHidden = false
             cameraImageView.isHidden = false
             btnCancel.layer.cornerRadius = btnCancel.layer.bounds.height / 2
             btnCancel.clipsToBounds = true
             btnCancel.backgroundColor = twitterBlue
             btnCancel.addTarget(self, action: #selector(toogleCancel), for: .touchUpInside)
             btnEdit.layer.cornerRadius = btnEdit.layer.bounds.height / 2
             btnEdit.clipsToBounds = true
             btnEdit.backgroundColor = twitterBlue
             btnEdit.addTarget(self, action: #selector(toogleEditor), for: .touchUpInside)
             btnPost.layer.cornerRadius = btnCancel.layer.bounds.height / 2
             btnPost.clipsToBounds = true
             btnPost.backgroundColor = twitterBlue
             if(isEditMode) {
                 btnEdit.setTitle("Save", for: UIControl.State.normal)
             }
             else{
                btnEdit.setTitle("Edit", for: UIControl.State.normal)
             }
             if isEditMode {
                 btnPost.isUserInteractionEnabled = false
             }
             else {
                 btnPost.isUserInteractionEnabled = true
             }
            // btnPost.addTarget(self, action: #selector(tooglePost), for: .touchUpInside)
             cameraImageView.tintColor = twitterBlue
        }
        else{
            btnCancel.isHidden = true
            btnEdit.isHidden = true
            btnPost.isHidden = true
            cameraImageView.isHidden = true
        }
    }
    /// Post toogler
//    @objc func tooglePost(sender: UIButton){
//        print(person?.id)
//        let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/entries" + (person?.id!)!)
//        guard let requestURL = url else { fatalError() }
//        var request = URLRequest(url: requestURL)
//        request.httpMethod = "PUT"
//        let picImage = person?.picture
//        let picImageData: Data = picImage!.jpegData(compressionQuality: 1)!
//        let picBase64 = picImageData.base64EncodedString()
//        let postString = "id = \(String(describing: person?.id))&netid = \(String(describing: person?.netid))&firstname=\(String(describing: person?.firstName))&lastname=\(String(describing: person?.lastName))&wherefrom=\(String(describing: person?.whereFrom))&gender=\(String(describing: person?.gender.description()))&role=\(String(describing: person?.role.description()))&degree=\(String(describing: person?.degree.description()))&team=\(String(describing: person?.team))&hobbies=\(String(describing: person?.hobbies))&languages=\(String(describing: person?.languages))&department=\(String(describing: person?.department))&email=\(String(describing: person?.email))&picture=\(String(describing: picBase64))"
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
    
    /// Cancel toogler
    @objc func toogleCancel(sender: UIButton){
        if addPage ?? false {
            clearInput()
        }
        else {
            isEditMode = false
            btnEdit.titleLabel?.text = "Edit"
            setUI(edit: editTextFieldToggle)
            textFieldDeactive()
        }
    }
    
    /// Edit / Save toogler
    @objc func toogleEditor(sender: UIButton){
        if isEditMode {
            if(addUpdateAction()){
                isEditMode = false
                btnEdit.setTitle("Edit", for: .normal)
                textFieldDeactive()
            }
        }
        else {
            isEditMode = true
            btnEdit.setTitle("Save", for: .normal)
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
    
    /// Set User Interface
    func setUI(edit: Bool){
        if edit {
            textFieldActive()
            
        }
        else {
            textFieldDeactive()
        }
        setButton()
        personImageView.layer.cornerRadius = personImageView.layer.bounds.height / 2
        personImageView.clipsToBounds = true
        firstNameField.text = person?.firstName
        lastNameField.text = person?.lastName
        genderField.text = person?.gender.description()
        roleField.text = person?.role.description()
        fromField.text = person?.whereFrom
        degreeField.text = person?.degree.description()
        let hobbies: String = printArray(strs: person?.hobbies ?? [] )
        hobbiesField.text = hobbies
        let languages: String = printArray(strs: person?.languages ?? [] )
        languagesField.text = languages
        teamField.text = person?.team
        emailField.text = person?.email
        if person != nil {
            personImageView.image = person?.picture
        }
        else {
        personImageView.image = UIImage(imageLiteralResourceName: "logo")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// ADD / UPDATE function
    func addUpdateAction() -> Bool
    {
        let firstName: String = firstNameField.text!
        let lastName: String = lastNameField.text!
        if firstName.isEmpty || lastName.isEmpty {
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
        let email:String = emailField.text!
        /// if person exists, update information
        for dukeperson in dukePersons {
            if dukeperson.firstName == firstName && dukeperson.lastName == lastName {
                dukeperson.whereFrom = from
                dukeperson.gender = gender
                dukeperson.hobbies = hobbies
                dukeperson.role = role
                dukeperson.degree = degree
                dukeperson.languages = languages
                dukeperson.team = team
                dukeperson.email = email
                dukeperson.picture = personImageView.image ?? UIImage(imageLiteralResourceName: "logo")
                dataEncoder()
                sections = createSections(personArray: dukePersons)
                createAlert(title: "DONE!", message: "\(firstName) \(lastName) is found! Personal Information has beed updated.")
                return true
            }
        }
        let newPerson: DukePerson = DukePerson(firstName: firstName, lastName: lastName, whereFrom: from, gender: gender, hobbies: hobbies, role: role, degree: degree , languages: languages, picture: personImageView.image ?? UIImage(imageLiteralResourceName: "logo"), team: team, netid: "", email: email, department: "", id: "", nextPage: "no", isFavourite: false)
        
        dukePersons.append(newPerson)
        dataEncoder()
        sections = createSections(personArray: dukePersons)
        createAlert(title: "DONE!", message: "\(firstName) \(lastName) has been added!")
        return true
        
    }
    
    /// return array of string
    private func getArray(input: String)->[String]{
        let split = input.components(separatedBy: [","])
        let array: [String] = Array(split)
        return array
     }
    
    /// clear all fields
    private func clearInput() {
        for field in textFields {
            field.text?.removeAll()
        }
    }
    
    /// pop-up alert
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

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
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
