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
    
    //    var mainModel = MainModel()
    var player: AVAudioPlayer?
    var timer = Timer()
    var count = 0
    var nowTurn: Player?
    var timerValue = 0
    
    let p1TimeKey = "p1_time"
    let p2TimeKey = "p2_time"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = UserDefaults.standard
        settings.register(defaults: [p1TimeKey: 10])
        settings.register(defaults: [p2TimeKey: 20])
        
        p2ButtonLabel.transform = flipUpsideDown()
    }
    //
    //    override func viewDidAppear(_ animated: Bool) {
    //        count = 0
    //    }
    
    @IBAction func playerButtonPressed(_ sender: UIButton) {
//        UIView.setAnimationsEnabled(false) //アニメーション無効化
        
        if let soundURL = Bundle.main.url(forResource: "Move2", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("error")
            }
        }
        timerStart()
        turnChange()
    }
    
    @IBAction func p1ButtonPressed(_ sender: UIButton) {
        nowTurn = .P2
    }
    
    @IBAction func p2ButtonPressed(_ sender: UIButton) {
        nowTurn = .P1
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        if let soundURL = Bundle.main.url(forResource: "Move3", withExtension: "mp3") {
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
        let settings = UserDefaults.standard
        
        switch nowTurn {
        case .P1:
            timerValue = settings.integer(forKey: p1TimeKey)
        case .P2:
            timerValue = settings.integer(forKey: p2TimeKey)
        case .none:
            print("displayUpdate()でエラー")
        }
        
        let remainCount = timerValue - count
        let stringRemainCount = String(remainCount)
        
        switch nowTurn {
        case .P1:
            p1ButtonLabel.setTitle(stringRemainCount, for: .normal)
        case .P2:
            p2ButtonLabel.setTitle(stringRemainCount, for: .normal)
        case .none:
            print("displayUpdate()でエラー")
        }
        
        return remainCount
    }
    
    func timerStart() {
        timer.invalidate()
        count = 0
        _ = displayUpdate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInterrupt(_:)), userInfo: nil, repeats: true)
    }
    
    func turnChange() {
        switch nowTurn {
        case .P1:
            p1ButtonLabel.backgroundColor = UIColor(hex: "B54434")
            p1ButtonLabel.setTitleColor(UIColor.white, for: .normal)
            p1ButtonLabel.isEnabled = true
            p2ButtonLabel.backgroundColor = UIColor(hex: "818181")
            p2ButtonLabel.setTitleColor(UIColor.darkGray, for: .normal)
            p2ButtonLabel.isEnabled = false
        case .P2:
            p2ButtonLabel.backgroundColor = UIColor(hex: "B54434")
            p2ButtonLabel.setTitleColor(UIColor.white, for: .normal)
            p2ButtonLabel.isEnabled = true
            p1ButtonLabel.backgroundColor = UIColor(hex: "818181")
            p1ButtonLabel.setTitleColor(UIColor.darkGray, for: .normal)
            p1ButtonLabel.isEnabled = false
            
        case .none:
            print("turnChange()でエラー")
        }
    }
    
    func flipUpsideDown() -> CGAffineTransform {
        let angle = 180 * CGFloat.pi / 180
        let flipUpsideDown = CGAffineTransform(rotationAngle: CGFloat(angle));
        return flipUpsideDown
    }
}

