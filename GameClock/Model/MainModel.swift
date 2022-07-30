//
//  MainModel.swift
//  GameClock
//
//  Created by IpoAbe on 2022/07/04.
//

import UIKit
import AVFoundation

class MainModel {
    private var player: Player = .P1
    var audioPlayer: AVAudioPlayer?
    var count = 0
    var p1Count = 0
    var p2Count = 0
    var totalSec = 0
    
    let audioSession = AVAudioSession.sharedInstance()
    
    func remainCount() -> Int {
        return totalSec - count
    }
    
    func resetTime(_ player: Player) {
        count = 0
        p1Count = 0
        p2Count = 0
        switch player {
        case .P1:
            totalSec = userDefaults.integer(forKey: p1TimeKey)
        case .P2:
            totalSec = userDefaults.integer(forKey: p2TimeKey)
        }
    }
    
    func setAllottedTime(_ player: Player) {
        switch player {
        case .P1:
            totalSec = userDefaults.integer(forKey: p1TimeKey)
            p2Count = count
            count = p1Count
        case .P2:
            totalSec = userDefaults.integer(forKey: p2TimeKey)
            p1Count = count
            count = p2Count
        }
    }
    
    
    
    func playSound(resource: String, ext: String) {
        if let soundURL = Bundle.main.url(forResource: resource, withExtension: ext) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                try audioSession.setCategory(.playback)
                audioPlayer?.play()
            } catch {
                print("playSoundでエラー")
            }
        }
    }
    
    func updateUD() -> String {
        count = 0
        let stringRemainCount = convertHMS(remainCount())
        return stringRemainCount
    }
    
    func flipUpsideDown() -> CGAffineTransform {
        let angle = 180 * CGFloat.pi / 180
        let flipUpsideDown = CGAffineTransform(rotationAngle: CGFloat(angle));
        return flipUpsideDown
    }
}

