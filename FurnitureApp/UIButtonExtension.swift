//
//  UIButtonExtension.swift
//  FurnitureApp
//
//  Created by Carl Claesson on 2018-11-16.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func pulsate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 2.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        
        layer.add(flash, forKey: nil)
    }
    
    func hideButton(){
        UIView.animate(withDuration: 0.6) {
            self.alpha = 0
           // self.superview?.constraints.first!.constant = -1000
        }
    }
    
    func showButton(){
        UIView.animate(withDuration: 0.6) {
            self.alpha = 1
           // self.superview?.constraints.first!.constant = 1000
        }
    }

    
}
