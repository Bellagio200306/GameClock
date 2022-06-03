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
    
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    var nowTurn: Player = .P1
    var gameStatus: GameStatus = .Paused
    var count = 0
    var totalSec = 0
    var player: AVAudioPlayer?
    var timer = Timer()
    var observedP1: NSKeyValueObservation?
    var observedP2: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p2Button.transform = flipUpsideDown()
        
        userDefaults.register(defaults: [p1TimeKey : 60])
        observedP1 = userDefaults.observe(\.p1TimeKey, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            self!.totalSec = change.newValue!
            self!.p1Button.setTitle(self!.updateUserDefaults(), for: .normal)
        })
        
        userDefaults.register(defaults: [p2TimeKey : 60])
        observedP2 = userDefaults.observe(\.p2TimeKey, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            self!.totalSec = change.newValue!
            self!.p2Button.setTitle(self!.updateUserDefaults(), for: .normal)
        })
    }
    
    func updateUserDefaults() -> String {
        count = 0
        let remainCount = totalSec - count
        let stringRemainCount = convertHMS(remainCount)
        return stringRemainCount
    }
    
    func playerButtonPressed(nowTurn: UIButton, restTurn: UIButton) {
        soundEffect(resouce: "Move2", ext: "mp3")
        gameStatus = .Playing
        changePauseImage(with: gameStatus)
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
        playerButtonPressed(nowTurn: p2Button, restTurn: p1Button)
    }
    
    @IBAction func p2ButtonPressed(_ sender: UIButton) {
        nowTurn = .P1
        totalSec = userDefaults.integer(forKey: p1TimeKey)
        playerButtonPressed(nowTurn: p1Button, restTurn: p2Button)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        switch gameStatus {
        case .Paused:
            gameStatus = .Playing
            startTimer()
            p1Button.isEnabled = true
            p2Button.isEnabled = true
            soundEffect(resouce: "Move2", ext: "mp3")
            changePauseImage(with: gameStatus)
            
        case .Playing:
            gameStatus = .Paused
            timer.invalidate()
            p1Button.isEnabled = false
            p2Button.isEnabled = false
            soundEffect(resouce: "Pause", ext: "mp3")
            changePauseImage(with: gameStatus)
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "タイマーをリセットしますか？", message: nil, preferredStyle: .actionSheet)
        let reset = UIAlertAction(title: "リセット", style: .destructive) { (action) in
            self.returnInitialSetting()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.startTimer()
        }
        
        alert.addAction(reset)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func returnInitialSetting() {
        let p1Time = userDefaults.integer(forKey: p1TimeKey)
        let p2Time = userDefaults.integer(forKey: p2TimeKey)
        
        gameStatus = .Paused
        nowTurn = .P1
        changePauseImage(with: gameStatus)
        count = 0
        totalSec = p1Time
        timer.invalidate()
        
        p1Button.setTitle(convertHMS(p1Time), for: .normal)
        p1Button.backgroundColor = UIColor(hex: "B54434")
        p1Button.setTitleColor(UIColor.white, for: .normal)
        p1Button.isEnabled = true
        
        p2Button.setTitle(convertHMS(p2Time), for: .normal)
        p2Button.backgroundColor = UIColor(hex: "818181")
        p2Button.setTitleColor(UIColor.darkGray, for: .normal)
        p2Button.isEnabled = true
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
        case .P1: p1Button.setTitle(stringRemainCount, for: .normal)
        case .P2: p2Button.setTitle(stringRemainCount, for: .normal)
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
    
    func changePauseImage(with gameStatus: GameStatus) {
        var imageName: String
        
        switch gameStatus {
        case .Paused: imageName = "PlayButton.png"
        case .Playing: imageName = "PauseButton.png"
        }
        
        let state = UIControl.State.normal
        let image = UIImage(named: imageName)
        pauseButton.setImage(image, for: state)
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
