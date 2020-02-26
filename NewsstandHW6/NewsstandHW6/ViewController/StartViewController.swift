//
//  StartViewController.swift
//  NewsstandHW6
//
//  Created by Duy Trieu on 2/25/20.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet var LogoImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LogoImg.image = UIImage(named: "AppIcon")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
