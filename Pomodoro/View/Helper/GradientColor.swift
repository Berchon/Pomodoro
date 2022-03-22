//
//  GradientColor.swift
//  Pomodoro
//
//  Created by Luciano Berchon on 10/03/22.
//

import Foundation
import QuartzCore
import UIKit

class GradientColor {
    private var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    func buildGradientColor(colorTop : CGColor, colorBottom : CGColor) -> CAGradientLayer {
        gradientLayer = CAGradientLayer()
//        gradientLayer.frame = object.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.7]
        
        return gradientLayer
    }
    
    static func createGradient(bounds: CGRect) -> CALayer {
        let topColor = CGColor(red: 90/255, green: 190/255, blue: 242/255, alpha: 1)
        let bottomColor = CGColor(red: 112/255, green: 216/255, blue: 243/255, alpha: 1)
        let background = GradientColor().buildGradientColor(colorTop: topColor, colorBottom: bottomColor)
        let originX = bounds.origin.x
        let width = bounds.width
        let height = bounds.height
        
        let newOriginY = height * 0.4
        let newHeight = height * 0.6
        
        background.frame = CGRect(x: originX, y: newOriginY, width: width, height: newHeight)
        return background
    }
}
