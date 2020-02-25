//
//  AnimationViewController.swift
//  ECE564_HOMEWORK
//
//  Created by Duy Trieu on 2/10/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class WorldVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayer()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLayer() {
        let worldLevel = WorldView()
        worldLevel.frame = CGRect(x: 50, y: 200, width: 300, height: 300)
        view?.addSubview(worldLevel)
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
