//
//  SwimmingVC.swift
//  NewsstandHW6
//
//  Created by student on 2/25/20.
//  Copyright © 2020 student. All rights reserved.
//
//
//  Swimming.swift
//  ECE564_HOMEWORK
//
//  Created by student on 2/8/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class SwimmingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect)
    {
        /* built the mainview*/
        let bgView=UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        //let transformB = CATransform3DMakeScale(0.5, 0.5, 0.5)
        bgView.backgroundColor = .blue
        
        self.addSubview(bgView)
         /* built the moon shape*/
        let moonpath=UIBezierPath(ovalIn: CGRect(x:0,y:0,width:90,height:90))
        let moonShape=CAShapeLayer()
        moonShape.path=moonpath.cgPath
        moonShape.lineWidth=3.0
        moonShape.strokeColor=UIColor.gray.cgColor
        moonShape.fillColor=UIColor.yellow.cgColor
        //headShape.transform=transformB
        moonShape.position=CGPoint(x:50,y:80)
        
        
        /*let bodyPath=CGMutablePath()
        bodyPath.addRoundedRect(in: CGRect(x:0,y:0,width:150,height:30), cornerWidth: 10, cornerHeight: 10)
        let bodyShape=CAShapeLayer()
        bodyShape.path = bodyPath
        bodyShape.lineWidth=3.0
        bodyShape.fillColor=UIColor.orange.cgColor
        bodyShape.transform=transformB
        bodyShape.position=CGPoint(x:50,y:220)
        bgView.layer.addSublayer(bodyShape)
        */
        /*let head=UIBezierPath(ovalIn:CGRect(x:0,y:0,width:300,height:100))
        UIColor.yellow.setFill()
        head.fill()
        */
         /* built the wave shape*/
        let wavePath=CGMutablePath()
        wavePath.move(to: CGPoint(x:-200,y:100))
        wavePath.addArc(tangent1End: CGPoint(x:-200,y:100), tangent2End: CGPoint(x:-150,y:150), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:-150,y:150), tangent2End: CGPoint(x:-100,y:100), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:-100,y:100), tangent2End: CGPoint(x:-50,y:50), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:-50,y:50), tangent2End: CGPoint(x:0,y:100), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:0,y:100), tangent2End: CGPoint(x:50,y:150), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:50,y:150), tangent2End: CGPoint(x:100,y:100), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:100,y:100), tangent2End: CGPoint(x:150,y:50), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:150,y:50), tangent2End: CGPoint(x:200,y:100), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:200,y:100), tangent2End: CGPoint(x:250,y:150), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:250,y:150), tangent2End: CGPoint(x:300,y:100), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:300,y:100), tangent2End: CGPoint(x:350,y:50), radius: 50)
        wavePath.addArc(tangent1End: CGPoint(x:350,y:50), tangent2End: CGPoint(x:400,y:100), radius: 50)
        wavePath.addLine(to: CGPoint(x:400,y:self.bounds.width))
        wavePath.addLine(to:CGPoint(x:-200,y:self.bounds.height))
        wavePath.closeSubpath()
        
        
        let waveShape=CAShapeLayer()
        waveShape.path=wavePath
        waveShape.position=CGPoint(x:0,y:300)
        waveShape.fillColor=UIColor.init(hue: 0.5, saturation: 0.3, brightness: 1.0, alpha:0.9 ).cgColor
        

        
        let swimAhead=CGMutablePath()
        swimAhead.move(to:CGPoint(x:0,y:0))
        swimAhead.addLine(to: CGPoint(x:200,y:0))
  
        let movepath=CGMutablePath()
        movepath.move(to:CGPoint(x:0,y:0))
        movepath.addArc(tangent1End: CGPoint(x:0,y:0), tangent2End: CGPoint(x:50,y:50), radius: 50)
        movepath.addArc(tangent1End: CGPoint(x:50,y:50), tangent2End: CGPoint(x:100,y:0), radius: 50)
        movepath.addArc(tangent1End: CGPoint(x:100,y:0), tangent2End: CGPoint(x:150,y:-50), radius: 50)
        movepath.addArc(tangent1End: CGPoint(x:150,y:-50), tangent2End: CGPoint(x:200,y:0), radius: 50)
        //movepath.closeSubpath()
         /* built the animation of shark move path*/
        let moveani=CAKeyframeAnimation(keyPath:"position")
        moveani.isAdditive=true
        moveani.path=movepath
        moveani.duration=2.0
        moveani.repeatCount=HUGE
        moveani.calculationMode=CAAnimationCalculationMode(rawValue: "paced")
        
        let swimforward=CAKeyframeAnimation(keyPath: "position")
        swimforward.isAdditive=true
        swimforward.path=swimAhead
        swimforward.duration=3.0
        swimforward.repeatCount=HUGE
        swimforward.calculationMode=CAAnimationCalculationMode(rawValue: "paced")
        //headShape.add(swimforward, forKey: "Head Forward")
        waveShape.add(swimforward, forKey:"Wave Move")
        
        
        let shark=UIImage(named:"Shark")?.cgImage
        let sharklayer=CAShapeLayer()
        sharklayer.contents=shark
        sharklayer.frame=CGRect(x:50,y:500,width:100,height:100)
        sharklayer.add(moveani, forKey: "Shark Swimming")
        bgView.layer.addSublayer(waveShape)
        bgView.layer.addSublayer(sharklayer)
        
        let fish=UIImage(named:"Fish")?.cgImage
        let fishlayer=CAShapeLayer()
        fishlayer.contents=fish
        fishlayer.frame=CGRect(x:200,y:450,width:150,height:150)
        fishlayer.add(moveani, forKey: "Fish Swimming")
        bgView.layer.addSublayer(fishlayer)
        bgView.layer.addSublayer(moonShape)
        setMovingSwimmerView()
        
    }
    
    func setMovingSwimmerView()
    {
        let myview=UIImageView()
        myview.frame=CGRect(x:50,y:380,width:100,height: 80)
        let i1=UIImage(named:"person1")!
        let i2=UIImage(named:"person2")!
        let i3=UIImage(named:"person3")!
        //let i3=UIImage(named:"swimming3")!
        let i1Resize=i1.resized(to: CGSize(width:100,height:150))
        let i2Resize=i2.resized(to:CGSize(width:100,height:150))
        let i3Resize=i3.resized(to: CGSize(width:100,height: 150))
        myview.animationImages=[i1Resize,i2Resize,i3Resize]
        myview.animationDuration=1
        myview.startAnimating()
        self.addSubview(myview)
    }
    
}
extension UIImage{
    
    func resized(to size:CGSize)-> UIImage{
        return UIGraphicsImageRenderer(size:size).image{ _ in draw(in: CGRect(origin: .zero, size:size))
            
        }
        
    }
    
}

