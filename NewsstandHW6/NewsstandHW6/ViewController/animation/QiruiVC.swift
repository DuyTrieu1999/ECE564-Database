//
//  Animation.swift
//  ECE564_HOMEWORK
//
//  Created by Qirui He on 2/14/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
//Animation Page
class QiruiVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setImageAnimationView()
        setBorder()
        // Do any additional setup after loading the view.
    }
    //Kobe's photos
    func setImageAnimationView() {
        let kobe = UIImageView()
        kobe.frame = CGRect(x: 40, y: 100, width: 300, height: 300)
        
        let i1 = UIImage(named: "1.png")!
        let i2 = UIImage(named: "2.png")!
        let i3 = UIImage(named: "3.png")!
        let i4 = UIImage(named: "4.png")!
        let i5 = UIImage(named: "5.png")!
        kobe.animationImages = [i1, i2, i3, i4, i5]
        kobe.animationDuration = 2
        kobe.startAnimating()
        view?.addSubview(kobe)
        
    }
    //draw border for picture
    func setBorder() {
        
        let frame = CGRect(x: 0, y: 0, width: 400, height: 500)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        
        let color2:UIColor = UIColor.purple
        let bpath2:UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 35, y: 95, width: 310, height: 310), cornerRadius: 10)
        color2.set()
        bpath2.lineWidth = 5
        bpath2.stroke()
        let saveImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let border = UIImageView()
        border.frame = frame
        border.image = saveImage
        view?.addSubview(border)
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
