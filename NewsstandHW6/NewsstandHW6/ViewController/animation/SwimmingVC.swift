//
//  SwimmingVC.swift
//  NewsstandHW6
//
//  Created by student on 2/25/20.
//  Copyright © 2020 student. All rights reserved.
//

import UIKit
import AVFoundation
class SwimmingVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let myPage=SwimmingView()
        myPage.frame=CGRect(x:0,y:0,width:self.view.bounds.width,height:self.view.bounds.height)
        self.view.addSubview(myPage)
        // Do any additional setup after loading the view.
    }

}
