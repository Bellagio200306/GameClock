//
//  ViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/01/31.
//

import UIKit
import AVFoundation

enum Player {
    case P1
    case P2
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var p1ButtonLabel: UIButton!
    @IBOutlet weak var p2ButtonLabel: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    var player: AVAudioPlayer?
    var timer = Timer()
    var observer: NSKeyValueObservation?
    var count = 0
    var nowTurn: Player = .P1
    var timerValue = 0
    var totalSec = 0
    
    let settings = UserDefaults.standard
    let p1TimeKey = "p1_time"
    let p2TimeKey = "p2_time"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p2ButtonLabel.transform = flipUpsideDown()
        
        observer = settings.observe(\.hour, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            print(UserDefaults.standard.integer(forKey: "hour"))
        })
        
        observer = settings.observe(\.min, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            print(UserDefaults.standard.integer(forKey: "min"))
        })
    }
    
    func playerButtonPressed(nowTurn: UIButton, restTurn: UIButton) {
        
        if let soundURL = Bundle.main.url(forResource: "Move2", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("error")
            }
        }
        
        startTimer()
        nowTurn.backgroundColor = UIColor(hex: "B54434")
        nowTurn.setTitleColor(UIColor.white, for: .normal)
        nowTurn.isEnabled = true
        restTurn.backgroundColor = UIColor(hex: "818181")
        restTurn.setTitleColor(UIColor.darkGray, for: .normal)
        restTurn.isEnabled = false
    }
    
    @IBAction func p1ButtonPressed(_ sender: UIButton) {
        nowTurn = .P2
        playerButtonPressed(nowTurn: p2ButtonLabel, restTurn: p1ButtonLabel)
    }
    
    @IBAction func p2ButtonPressed(_ sender: UIButton) {
        nowTurn = .P1
        playerButtonPressed(nowTurn: p1ButtonLabel, restTurn: p2ButtonLabel)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        if let soundURL = Bundle.main.url(forResource: "Pause", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("error")
            }
        }
    }
    
    @objc func timerInterrupt(_ timer: Timer) {
        count += 1
        if displayUpdate() <= 0 {
            count = 0
            timer.invalidate()
        }
    }
    
    func displayUpdate() -> Int {
        
        let remainCount = totalSec - count
        let hour = String(remainCount / 3600)
        let min = String(remainCount % 3600 / 60)
        let sec = String(remainCount % 3600 % 60)
        let stringRemainCount = "\(hour):\(min):\(sec)"
        
        switch nowTurn {
        case .P1:
            p1ButtonLabel.setTitle(stringRemainCount, for: .normal)
        case .P2:
            p2ButtonLabel.setTitle(stringRemainCount, for: .normal)
        }
        
        return remainCount
    }
    
    func startTimer() {
        timer.invalidate()
        count = 0
        _ = displayUpdate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInterrupt(_:)), userInfo: nil, repeats: true)
    }
    
    func flipUpsideDown() -> CGAffineTransform {
        let angle = 180 * CGFloat.pi / 180
        let flipUpsideDown = CGAffineTransform(rotationAngle: CGFloat(angle));
        return flipUpsideDown
    }
    
    func totalSecConversion() {
        let hour = settings.integer(forKey: "hour")
        let min = settings.integer(forKey: "min")
        let sec = settings.integer(forKey: "sec")
        totalSec = hour * 60 * 60 + min * 60 + sec
    }
}

extension UserDefaults {
    @objc dynamic var hour: Int {
        return integer(forKey: "hour")
    }
    @objc dynamic var min: Int {
        return integer(forKey: "min")
    }
    @objc dynamic var sec: Int {
        return integer(forKey: "sec")
    }
}
