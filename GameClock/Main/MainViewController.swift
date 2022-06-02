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

enum GameStatus {
    case Paused
    case Playing
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var p1ButtonLabel: UIButton!
    @IBOutlet weak var p2ButtonLabel: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    var player: AVAudioPlayer?
    var timer = Timer()
    var count = 0
    var nowTurn: Player = .P1
    var gameStatus: GameStatus = .Paused
    var totalSec = 0
    var observedP1: NSKeyValueObservation?
    var observedP2: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p2ButtonLabel.transform = flipUpsideDown()
        
        userDefaults.register(defaults: [p1TimeKey : 60])
        observedP1 = userDefaults.observe(\.p1TimeKey, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            self!.totalSec = change.newValue!
            self!.p1ButtonLabel.setTitle(self!.updateUserDefaults(), for: .normal)
        })
        
        userDefaults.register(defaults: [p2TimeKey : 60])
        observedP2 = userDefaults.observe(\.p2TimeKey, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            self!.totalSec = change.newValue!
            self!.p2ButtonLabel.setTitle(self!.updateUserDefaults(), for: .normal)
        })
    }
    
    func playerButtonPressed(nowTurn: UIButton, restTurn: UIButton) {
        
        soundEffect(resouce: "Move2", ext: "mp3")
        gameStatus = .Playing
        count = 0
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
        totalSec = userDefaults.integer(forKey: p2TimeKey)
        playerButtonPressed(nowTurn: p2ButtonLabel, restTurn: p1ButtonLabel)
    }
    
    @IBAction func p2ButtonPressed(_ sender: UIButton) {
        nowTurn = .P1
        totalSec = userDefaults.integer(forKey: p1TimeKey)
        playerButtonPressed(nowTurn: p1ButtonLabel, restTurn: p2ButtonLabel)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        
        switch gameStatus {
        case .Playing:
            timer.invalidate()
            p1ButtonLabel.isEnabled = false
            p2ButtonLabel.isEnabled = false
            soundEffect(resouce: "Pause", ext: "mp3")
            changePauseImage(gameStatus: .Playing)
            gameStatus = .Paused
            
        case .Paused:
            startTimer()
            p1ButtonLabel.isEnabled = true
            p2ButtonLabel.isEnabled = true
            soundEffect(resouce: "Move2", ext: "mp3")
            changePauseImage(gameStatus: .Paused)
            gameStatus = .Playing
        }
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        gameStatus = .Paused
    }
    
    @objc func timerInterrupt(_ timer: Timer) {
        if totalSec - count < 1 {
            count = 0
            timer.invalidate()
        } else {
            count += 1
            displayUpdate()
        }
    }
    
    func displayUpdate() {
        let remainCount = totalSec - count
        let stringRemainCount = convertHMS(remainCount)
        
        switch nowTurn {
        case .P1: p1ButtonLabel.setTitle(stringRemainCount, for: .normal)
        case .P2: p2ButtonLabel.setTitle(stringRemainCount, for: .normal)
        }
    }
    
    func startTimer() {
        timer.invalidate()
        displayUpdate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInterrupt(_:)), userInfo: nil, repeats: true)
    }
    
    func flipUpsideDown() -> CGAffineTransform {
        let angle = 180 * CGFloat.pi / 180
        let flipUpsideDown = CGAffineTransform(rotationAngle: CGFloat(angle));
        return flipUpsideDown
    }
    
    func soundEffect(resouce: String, ext: String) {
        if let soundURL = Bundle.main.url(forResource: resouce, withExtension: ext) {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.play()
            } catch {
                print("soundEffectでエラー")
            }
        }
    }
    
    func changePauseImage(gameStatus: GameStatus) {
        
        var imageName: String
        
        switch gameStatus {
        case .Paused: imageName = "PauseButton.png"
        case .Playing: imageName = "PlayButton.png"
        }
        
        let state = UIControl.State.normal
        let image = UIImage(named: imageName)
        pauseButton.setImage(image, for: state)
    }
    
    func updateUserDefaults() -> String {
        count = 0
        let remainCount = totalSec - count
        let stringRemainCount = convertHMS(remainCount)
        return stringRemainCount
    }
}

extension UserDefaults {
    @objc dynamic var p1TimeKey: Int {
        return integer(forKey: "p1TimeKey")
    }
    @objc dynamic var p2TimeKey: Int {
        return integer(forKey: "p2TimeKey")
    }
}
