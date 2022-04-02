//
//  GCBrain.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/01/31.
//

import UIKit

class GCBrain {
    
    
    
    func flipUpsideDown() -> CGAffineTransform {
        
        let angle = 180 * CGFloat.pi / 180
        let flipUpsideDown = CGAffineTransform(rotationAngle: CGFloat(angle));
        return flipUpsideDown
    }
    
    
    func timeString(time: Int) -> String {
//        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes,seconds)
    }
    
    
}
