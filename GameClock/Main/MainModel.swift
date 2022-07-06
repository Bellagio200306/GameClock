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
    private var timer = Timer()
    private var audioPlayer: AVAudioPlayer?
    private var count = 0
    var totalSec = 0
    
    
    func startTimer(_ player: UIButton) {
        timer.invalidate()
//        displayUpdate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInterrupt(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func timerInterrupt(_ timer: Timer) {
        let nowTime = totalSec - count
        
        switch  nowTime {
        case 11,21,31:/*１０秒前、２０秒前、３０秒前*/
            playSound(resource: "poon", ext: "mp3")
            countDown()
        case 5...10:/*９秒前〜４秒前*/
            playSound(resource: "pi", ext: "mp3")
            countDown()
        case 4:/*３秒前*/
            playSound(resource: "beep", ext: "mp3")
            countDown()
        case 1:/*時間切れ*/
            timer.invalidate()
            audioPlayer?.stop()
            switch player {
            case .P1:
                timeOut(at: p1Button)
            case .P2:
                timeOut(at: p2Button)
            }
        default:
            countDown()
        }
    }
    
    func timeOut(at player: UIButton) {
        player.isEnabled = false
        pauseButton.isEnabled = false
        player.setTitle("Lose.", for: .normal)
    }
    
    func countDown() {
        count += 1
        displayUpdate()
    }
    
    func displayUpdate() {
        let remainCount = totalSec - count
        let stringRemainCount = convertHMS(remainCount)
        
        switch player {
        case .P1: p1Button.setTitle(stringRemainCount, for: .normal)
        case .P2: p2Button.setTitle(stringRemainCount, for: .normal)
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func resetCount() {
        count = 0
    }
    
    func setInitialTimer(setTotalSec: Int) {
        resetCount()
        stopTimer()
        totalSec = setTotalSec
    }
    
    func setTotalSec(_ player: Player) {
        switch player {
        case .P1:
            totalSec = userDefaults.integer(forKey: p1TimeKey)
        case .P2:
            totalSec = userDefaults.integer(forKey: p2TimeKey)
        }
    }
    
    func playSound(resource: String, ext: String) {
        if let soundURL = Bundle.main.url(forResource: resource, withExtension: ext) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("playSoundでエラー")
            }
        }
    }
    
    func updateUserDefaults() -> String {
        resetCount()
        let remainCount = totalSec - count
        let stringRemainCount = convertHMS(remainCount)
        return stringRemainCount
    }
    
    func flipUpsideDown() -> CGAffineTransform {
        let angle = 180 * CGFloat.pi / 180
        let flipUpsideDown = CGAffineTransform(rotationAngle: CGFloat(angle));
        return flipUpsideDown
    }
}
