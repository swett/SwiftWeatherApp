//
//  WeatherEffects.swift
//  WetherApp
//
//  Created by Vitaliy Griza on 07.09.2022.
//

import UIKit

class WeatherEffects: NSObject {

    
    
    func runningCloud(view: UIImageView, photo: Int) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
//            view.snp.updateConstraints { make in
//                make.left.equalTo(200)
//            }
            if photo == 0 {
                view.center.x += 270
            }
            if photo == 1 {
                    view.center.x += 210
            }
            if photo == 2 {
                view.center.x += 200
            }

            
        } completion: { com in
            self.animateClouds(view: view, photo: photo)
        }
    }
    
    func animateClouds(view: UIImageView, photo: Int) {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut) {
            view.alpha = 1
            if photo == 0 {
                
                view.center.x = 90
                view.frame.origin.x += 40
            } else if photo == 1 {
                view.center.x = 10
                view.frame.origin.x += 40
                
            } else {
                view.center.x = 70
                view.frame.origin.x += 140
                
            }
//                self.view.layoutIfNeeded()
        } completion: { com in
            if com {
                if photo == 0 {
                    self.runningCloud(view: view, photo: photo)
                }
                if photo == 1 {
                    self.runningCloud(view: view, photo: photo)
                }
                if photo == 2 {
                    self.runningCloud(view: view, photo: photo)
                }
                
            }
            
        }
    }
    
    
    func cloudViews (photoName: [String], view: UIView){
        
        for photo in 0..<photoName.count {
            let imageView = UIImageViewWithMask().then({ photoView in
                view.addSubview(photoView)
                photoView.maskImage = UIImage(named: "cloud4")
                photoView.image = UIImage(named: photoName[photo])
                photoView.alpha = 0
                
//                photoView.layer.masksToBounds = true
//
                
                if photo == 0 {
                    photoView.frame = CGRect(x: 60, y: -80, width: 150, height: 105)
                } else if photo == 1 {
                    photoView.frame = CGRect(x: 10, y: -50, width: 150, height: 100)
                } else {
                    photoView.frame = CGRect(x: 120, y: -50, width: 150, height: 100)
                }
            })
            print(photo)
            animateClouds(view: imageView, photo: photo)
            
//                self.theImageViews.append(imageView)
        }
    }
    
    
    
    func sun (view: UIView){
        let imageView = UIImageViewWithMask().then { image in
            view.addSubview(image)
            image.maskImage = UIImage(named: "sun")
            image.image = UIImage(named: "SANYA")

            image.snp.makeConstraints { make in
                make.width.height.equalTo(200)
                make.right.equalToSuperview()
            }
        }
                    
    }
    
    
    func snow(velocity: Float, view: UIView, snow: Bool){
        let emmiter = RainAndSnowView.get(with: UIImage(named: "snowflake4")!, velocity: velocity, isSnowing: snow)
        emmiter.emitterPosition = CGPoint(x: view.frame.width/2, y: 10)
        emmiter.emitterSize = CGSize(width: view.frame.width, height: 2)
        view.layer.insertSublayer(emmiter, at: 0)
        
    }
    
    func rain(velocity: Float, view: UIView, snow: Bool) {
       
        let emmiter = RainAndSnowView.get(with: UIImage(named: "rainn5")!, velocity: velocity, isSnowing: snow)
        emmiter.emitterPosition = CGPoint(x: 200, y: 60)
        emmiter.emitterSize = CGSize(width: 400, height: 2)
        emmiter.opacity = 0.4
//        emmiter.velocity = velocity
        view.layer.insertSublayer(emmiter, at: 0)
    
    }
    
    func createLine(pointA: CGPoint, pointB: CGPoint)-> CAShapeLayer {
        let pathToDraw = UIBezierPath()
        pathToDraw.move(to: pointA)
        pathToDraw.addLine(to: pointB)
        let line = CAShapeLayer()
        line.lineWidth = 2
        line.path = pathToDraw.cgPath
        line.strokeColor = UIColor.black.cgColor
        line.opacity = 0
        return line
    }
    
    func genrateLightningPath(startingFrom: CGPoint) -> [CAShapeLayer] {
        var strikePath: [CAShapeLayer] = []
        var startPoint = startingFrom
        var endPoint = startPoint
        let numberOfLines = 40
        
        var idx = 0
        while idx < numberOfLines {
            strikePath.append(createLine(pointA: startPoint, pointB: endPoint))
            startPoint = endPoint
            let r = CGFloat(10)
            endPoint.x += CGFloat.random(in: -r ... r)
            endPoint.y -= r
            idx += 1
        }
        return strikePath
    }
    
    func lightningStrike(throughPath: [CAShapeLayer],view:UIView) {
        for line in throughPath {
            animateLighting(line: line)
            view.layer.insertSublayer(line, at: 0)
        }
    }
    
    func animateLighting(line: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        line.add(animation, forKey: "fade")
        
    }
    
    
}
