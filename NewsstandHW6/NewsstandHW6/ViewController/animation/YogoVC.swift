//
//  ReadingVC.swift
//  ECE564_HOMEWORK
//
//  Created by student on 2/11/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import AVFoundation

class YogoVC: UIViewController {

    var trackerLayer: CAShapeLayer!
    var bgrCircle: CAShapeLayer!
    var countFired: CGFloat = 0
    var pulsatingCircle: CAShapeLayer!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var yogoImages: [UIImage]!
    var thread: CGFloat = 100
    var bgrMusicPlayer: AVAudioPlayer!
    var isTapped: Bool = false
    @IBOutlet weak var yogoImageView: UIImageView!
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    let screenRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        let caloriePos = CGPoint(x: screenWidth - 80, y: 140)
        yogoImages = createImageArray(total: 8, imagePrefix: "pose")
        
        setCalorieUI(center: caloriePos)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(calorieClock)))
        setPercentageUI(center: caloriePos)
        yogoImageView.image = UIImage(imageLiteralResourceName: "pose_0")
    }

    private func playBackgroundMusic(music: String) {
        let url = Bundle.main.url(forResource: music, withExtension: nil)
        guard let newUrl =  url else{
            print("Could not find embeded background music")
            return
        }
        do {
            bgrMusicPlayer = try AVAudioPlayer(contentsOf: newUrl)
            bgrMusicPlayer.numberOfLoops = 1
            bgrMusicPlayer.prepareToPlay()
            bgrMusicPlayer.play()
        }
        catch let error as NSError {
            print(error.description)
        }
    }
    private func setPercentageUI(center: CGPoint) {
         view.addSubview(percentageLabel)
         percentageLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
         percentageLabel.center = center
    }
    
    private func createCircleLayer(strokeColor: UIColor, fillColor: UIColor, center: CGPoint, lineWidth: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 40, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = center
        return layer
    }
    
    private func setCalorieUI(center: CGPoint) {
        // set pulsating circle
        pulsatingCircle = createCircleLayer(strokeColor:UIColor.clear, fillColor: UIColor.pulsatingFillColor, center: center, lineWidth: 5)
        view.layer.addSublayer(pulsatingCircle)
        
        // set up background circle
        bgrCircle = createCircleLayer(strokeColor:UIColor.trackStrokeColor, fillColor: UIColor.white, center: center, lineWidth: 10)
        view.layer.addSublayer(bgrCircle)
        
        animatePulsatingCircle()
        
        // set up changing circle
        trackerLayer = createCircleLayer(strokeColor:UIColor.outlineStrokeColor, fillColor: UIColor.clear, center: center, lineWidth: 8)
        trackerLayer.transform = CATransform3DMakeRotation(0, 0, 0, 1)
        trackerLayer.strokeEnd = 0
        view.layer.addSublayer(trackerLayer)
  }
    
    private func createCircleLayer(strokeColor: UIColor, fillColor: UIColor, pos: CGPoint) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 60, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 5
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = pos
        return layer
    }
    private func animatePulsatingCircle() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.5
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingCircle.add(animation, forKey: "pulsing")
    }
    
    // Tap calorie clock animation
    @objc private func calorieClock() {
        countFired =  0
        playBackgroundMusic(music: "pili.mp3")
        yogoAnimation(imageView: yogoImageView, images: yogoImages)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            self.countFired += 1
            let percentage = self.countFired / self.thread
            DispatchQueue.main.async {
               self.percentageLabel.text = "\(Int(percentage * 500))"
               self.trackerLayer.strokeEnd = percentage
                if self.countFired == self.thread {
                   timer.invalidate()
                    self.yogoImageView.image = UIImage(imageLiteralResourceName: "pose_0")
                    self.bgrMusicPlayer.stop()
               }
             }
        }

    }
    
    private func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        for imageCount in 0..<total {
            let imageTitle = "\(imagePrefix)_\(imageCount)"
            let image = UIImage(imageLiteralResourceName: imageTitle)
            imageArray.append(image)
        }
        return imageArray
    }

    private func yogoAnimation(imageView: UIImageView, images: [UIImage]) {
        yogoImageView.animationImages = images
        yogoImageView.animationDuration = TimeInterval(self.thread / 20)
        yogoImageView.animationRepeatCount = 2
        yogoImageView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (self.bgrMusicPlayer != nil && self.bgrMusicPlayer.isPlaying) {
           self.bgrMusicPlayer.stop()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animatePulsatingCircle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 235, g: 112, b: 112)
    static let trackStrokeColor = UIColor.rgb(r: 226, g: 167, b: 167)
    static let pulsatingFillColor = UIColor.rgb(r: 245, g: 213, b: 213)
}

















