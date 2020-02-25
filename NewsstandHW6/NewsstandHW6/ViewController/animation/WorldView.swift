//
//  WorldView.swift
//  ECE564_HOMEWORK
//
//  Created by Duy Trieu on 2/14/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class WorldView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override class var layerClass : AnyClass {
        return WorldLayer.self
    }
    

}
class WorldLayer: CALayer, CALayerDelegate {
    var person: CALayer?
    
    override func layoutSublayers() {
        self.setup()
    }
    
    func setup() {
        let world = CALayer()
        let worldImg = UIImage(named: "around the world")?.cgImage
        world.frame = self.bounds
        world.contents = worldImg
        self.addSublayer(world)
        
        let human = CALayer()
        let humanImg = UIImage(named: "walking man")?.cgImage
        human.contents = humanImg
        human.frame = CGRect(x: 100, y: 100, width: 40, height: 50)
        human.position = CGPoint(x: 150, y: 50)
        self.addSublayer(human)
        
        let radius: CGFloat = 10
        let jumpingPath = CGMutablePath()
        jumpingPath.move(to: CGPoint(x: 0, y: -radius))
        jumpingPath.addArc(center: .zero, radius: radius, startAngle: 3 * .pi/2, endAngle: .pi/2, clockwise: true)
        
        let worldPath = CGMutablePath()
        worldPath.move(to: CGPoint(x: 150, y: 50))
        worldPath.addEllipse(in: CGRect(x: -100,y: 0,width: 200,height: 200))
        
        let followJumpPath = CAKeyframeAnimation(keyPath: "position")
        followJumpPath.isAdditive = true
        followJumpPath.path = jumpingPath
        followJumpPath.duration = 1
        followJumpPath.repeatCount = HUGE
        followJumpPath.calculationMode = CAAnimationCalculationMode(rawValue: "paced")
        
        let followWorldPath = CAKeyframeAnimation(keyPath: "position")
        followWorldPath.isAdditive = true
        followWorldPath.path = worldPath
        followWorldPath.duration = 10
        followWorldPath.repeatCount = HUGE
        followWorldPath.calculationMode = CAAnimationCalculationMode(rawValue: "paced")
        self.person = human
        //self.personRotate360(duration: 15)
        
        human.add(followJumpPath, forKey: "jump up and down")
        human.add(followWorldPath, forKey: "follow the world")
        
        
    }
    func personRotate360(duration: Double = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = Float.infinity
        if let person = self.person {
            person.add(rotateAnimation, forKey: "rotateViewAnimation")
        }
    }
}
