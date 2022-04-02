//
//  ViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/01/31.
//
//test coment

import UIKit
import AVFoundation

class GCViewController: UIViewController {
    
    @IBOutlet weak var p1ButtonLabel: UIButton!
    @IBOutlet weak var p2ButtonLabel: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    var gcBrain = GCBrain()
    var timer = Timer()
    var count = 0
    var player: AVAudioPlayer?
    var whosTurn: String?
    var timerValue = 0
    
    let p1TimeKey = "p1_time"
    let p2TimeKey = "p2_time"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = UserDefaults.standard
        settings.register(defaults: [p1TimeKey: 10])
        settings.register(defaults: [p2TimeKey: 20])
        
        p2ButtonLabel.transform = gcBrain.flipUpsideDown()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        count = 0
    }
    
    @IBAction func playerButtonPressed(_ sender: UIButton) {
        UIView.setAnimationsEnabled(false) //アニメーション無効化
        
        if let soundURL = Bundle.main.url(forResource: "Move", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("error")
            }
        }
    }
    
    @IBAction func p1ButtonPressed(_ sender: UIButton) {
        whosTurn = "p2"
        timer.invalidate()
        count = 0
        _ = displayUpdate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInterrupt(_:)), userInfo: nil, repeats: true)
        
        p2ButtonLabel.backgroundColor = UIColor(hex: "B54434")
        p2ButtonLabel.setTitleColor(UIColor.white, for: .normal)
        p2ButtonLabel.isEnabled = true
        p1ButtonLabel.backgroundColor = UIColor(hex: "818181")
        p1ButtonLabel.setTitleColor(UIColor.darkGray, for: .normal)
        p1ButtonLabel.isEnabled = false
        
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
        if whosTurn == "p2" {
            timerValue = settings.integer(forKey: p2TimeKey)
        } else if whosTurn == "p1" {
            timerValue = settings.integer(forKey: p1TimeKey)
        } else {
            print("Error in displayUpdate")
        }
        
        let remainCount = timerValue - count
        let stringRemainCount = String(remainCount)
        if whosTurn == "p2" {
            p2ButtonLabel.setTitle(stringRemainCount, for: .normal)
        } else if whosTurn == "p1" {
            p1ButtonLabel.setTitle(stringRemainCount, for: .normal)
        } else {
            print("Error in displayUpdate2")
        }
        
        return remainCount
    }
    
    
    @IBAction func p2ButtonPressed(_ sender: UIButton) {
        whosTurn = "p1"
        timer.invalidate()
        count = 0
        _ = displayUpdate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInterrupt(_:)), userInfo: nil, repeats: true)
        
        p1ButtonLabel.backgroundColor = UIColor(hex: "B54434")
        p1ButtonLabel.setTitleColor(UIColor.white, for: .normal)
        p1ButtonLabel.isEnabled = true
        p2ButtonLabel.backgroundColor = UIColor(hex: "818181")
        p2ButtonLabel.setTitleColor(UIColor.darkGray, for: .normal)
        p2ButtonLabel.isEnabled = false
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        if let soundURL = Bundle.main.url(forResource: "Pause sound", withExtension: "wav") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("error")
            }
        }
    }
}

