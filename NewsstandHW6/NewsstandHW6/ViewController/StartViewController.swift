//
//  StartViewController.swift
//  NewsstandHW6
//
//  Created by Duy Trieu on 2/25/20.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit
import shibauthframework2019

class StartViewController: UIViewController {
    /// curr netid
    var currNetID: String?
    var currPassword: String?
    /// button and logo
    @IBOutlet var LogoImg: UIImageView!
    @IBOutlet var LogInButton: UIButton!
    let twitterBlue: UIColor = UIColor(red: 29.0/255.0, green: 161.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LogInButton.backgroundColor = twitterBlue
        setUpView()
    }
    func setUpView() {
        LogoImg.image = UIImage(imageLiteralResourceName: "Duke_logo")
        self.view.backgroundColor = .white
        self.LogInButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    @objc func logIn() {
        let alertController = LoginAlert(title: "Authenticate", message: nil, preferredStyle: .alert)
        alertController.delegate = self
        self.present(alertController, animated: true, completion: nil)
    }
    

}
extension StartViewController: LoginAlertDelegate {
    
    func onSuccess(_ loginAlertController: LoginAlert, didFinishSucceededWith status: LoginResults, netidLookupResult: NetidLookupResultData?, netidLookupResultRawData: Data?, cookies: [HTTPCookie]?, lastLoginTime: Date) {
        // succeeded, extract netidLookupResult.id and netidLookupResult.password for your server credential
        // other properties needed for homework are also in netidLookupResult
        let curId = netidLookupResult?.netid
        let curPassword = netidLookupResult?.password
        print("netID is: \(curId!)")
        print("password is: \(curPassword!)")
        currNetID = curId
        currPassword = curPassword
    }
    
    func onFail(_ loginAlertController: LoginAlert, didFinishFailedWith reason: LoginResults) {
        // when authentication fails, this method will be called.
        // default implementation provided
    }
    
    func inProgress(_ loginAlertController: LoginAlert, didSubmittedWith status: LoginResults) {
        // this method will get called for each step in progress.
        // default implementation provided
        let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/user")
        guard let requestURL = url else { fatalError() }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let postString = "id=\(String(describing: currNetID))&password=\(String(describing: currPassword))"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let httpRequest = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
        }
        httpRequest.resume()
    }
    
    func onLoginButtonTapped(_ loginAlertController: LoginAlert) {
        // the login button on the alert is tapped
        // default implementation provided
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tableView = storyBoard.instantiateViewController(withIdentifier: "tableView") as! MasterTableVC
        tableView.curNetID = currNetID
        navigationController?.pushViewController(tableView,
               animated: true)
        //self.present(tableView, animated: true, completion: nil)
    }

    func onCancelButtonTapped(_ loginAlertController: LoginAlert) {
        // the cancel button on the alert is tapped
        // default implementation provided
    }
}
