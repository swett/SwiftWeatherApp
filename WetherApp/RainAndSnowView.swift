//
//  CloudView.swift
//  WetherApp
//
//  Created by Nikita Kurochka on 11.08.2022.
//

import UIKit

class RainAndSnowView {
    public static let dimension = 4
    public static var imagesNames = ["kurka12", "den2", "sanya2", "vetal2", "vadim2", "glebas2"]
   public static func get(with image: UIImage, velocity: Float, isSnowing: Bool) -> CAEmitterLayer{
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterCells = generateEmitterCells(with: image, velocity: velocity, snow: isSnowing)
        
        return emitter
    }
     public static func generateEmitterCells(with image: UIImage, velocity: Float, snow: Bool) -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        if snow == true {
            let cell = CAEmitterCell()
           cell.contents = image.cgImage
            cell.birthRate = 7
            cell.lifetime = 5
            cell.velocity = CGFloat(velocity)
            cell.velocityRange = 30
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi/4
            cell.scale = 0.1
            cells.append(cell)
        } else {
            for index in 0..<6 {
                let cell = CAEmitterCell()
                cell.contents = nextImage(i: index)
                cell.birthRate = 2
                cell.lifetime = 5
                cell.velocity = CGFloat(velocity)
                cell.velocityRange = 40
                cell.emissionLongitude = .pi
                cell.emissionRange = .pi/4
                cell.scale = 0.4
    
                cells.append(cell)
                    }
        }
        
        
        
        return cells
    }
    
   public static func nextImage(i: Int) -> CGImage? {
//       print(imagesNames[i])
        let image = UIImage(named:"\(imagesNames[i])")
            return image?.cgImage
//       return UIImage(named: "den2")?.cgImage
        }
    
    func combine3(_ bg: UIImage, cover: UIImage, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()!
        let maskRef = cover.cgImage!
        let mask = CGImage.init(maskWidth: maskRef.width, height: maskRef.height, bitsPerComponent: maskRef.bitsPerComponent, bitsPerPixel: maskRef.bitsPerPixel, bytesPerRow: maskRef.bytesPerRow, provider: maskRef.dataProvider!, decode: nil, shouldInterpolate: false)!
        let masked = bg.cgImage!.masking(mask)!
        // adjust for lower-left-origin CG coordinates
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        context.draw(masked, in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension UIColor {
        convenience init(red: Int, green: Int, blue: Int) {
                   assert(red >= 0 && red <= 255, "Invalid red component")
                   assert(green >= 0 && green <= 255, "Invalid green component")
                   assert(blue >= 0 && blue <= 255, "Invalid blue component")

                   self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
               }

        convenience init(rgb: Int) {
                   self.init(
                       red: (rgb >> 16) & 0xFF,
                       green: (rgb >> 8) & 0xFF,
                       blue: rgb & 0xFF
                   )
               }
            }
