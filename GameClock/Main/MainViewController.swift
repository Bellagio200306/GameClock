//
//  ViewController.swift
//  GameClock
//
//  Created by IpoAbe on 2022/01/31.
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
    var audioPlayer: AVAudioPlayer?
    var timer = Timer()
    var observedP1: NSKeyValueObservation?
    var observedP2: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p2Button.transform = flipUpsideDown()
        setInitialState()
        
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
    
    func playerButtonPressed(nowTurn: UIButton, breakTurn: UIButton) {
        soundEffect(resource: "Move2", ext: "mp3")
        gameStatus = .Playing
        changePauseImage(with: gameStatus)
        count = 0
        startTimer()
        nowTurn.backgroundColor = UIColor(named: "PlayingTurnColor")
        nowTurn.setTitleColor(UIColor.white, for: .normal)
        nowTurn.isEnabled = true
        breakTurn.backgroundColor = UIColor(named: "BreakTurnColor")
        breakTurn.setTitleColor(UIColor.darkGray, for: .normal)
        breakTurn.isEnabled = false
    }
    
    @IBAction func p1ButtonPressed(_ sender: UIButton) {
        nowTurn = .P2
        totalSec = userDefaults.integer(forKey: p2TimeKey)
        playerButtonPressed(nowTurn: p2Button, breakTurn: p1Button)
    }
    
    @IBAction func p2ButtonPressed(_ sender: UIButton) {
        nowTurn = .P1
        totalSec = userDefaults.integer(forKey: p1TimeKey)
        playerButtonPressed(nowTurn: p1Button, breakTurn: p2Button)
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        switch gameStatus {
        case .Paused:
            gameStatus = .Playing
            startTimer()
            p1Button.isEnabled = true
            p2Button.isEnabled = true
            soundEffect(resource: "Move2", ext: "mp3")
            changePauseImage(with: gameStatus)
            
        case .Playing:
            gameStatus = .Paused
            timer.invalidate()
            p1Button.isEnabled = false
            p2Button.isEnabled = false
            soundEffect(resource: "Pause", ext: "mp3")
            changePauseImage(with: gameStatus)
        }
    }
    
    func changePauseImage(with gameStatus: GameStatus) {
        var imageName: String
        
        switch gameStatus {
        case .Paused: imageName = "PlayButton.png"
        case .Playing: imageName = "PauseButton.png"
        }
        
        let image = UIImage(named: imageName)
        pauseButton.setImage(image, for: .normal)
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "リセットしますか？", message: nil, preferredStyle: .alert)
        let reset = UIAlertAction(title: "リセット", style: .destructive) {_ in
            self.setInitialState()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            self.dismiss(animated: true)
            self.startTimer()
        }
        
        alert.addAction(reset)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func setInitialState() {
        let p1Time = userDefaults.integer(forKey: p1TimeKey)
        let p2Time = userDefaults.integer(forKey: p2TimeKey)
        
        gameStatus = .Paused
        nowTurn = .P1
        changePauseImage(with: gameStatus)
        count = 0
        totalSec = p1Time
        timer.invalidate()
        pauseButton.isEnabled = true
        
        p1Button.setTitle(convertHMS(p1Time), for: .normal)
        p1Button.backgroundColor = UIColor(named: "PlayingTurnColor")
        p1Button.setTitleColor(.white, for: .normal)
        p1Button.isEnabled = true
        
        p2Button.setTitle(convertHMS(p2Time), for: .normal)
        p2Button.backgroundColor = UIColor(named: "BreakTurnColor")
        p2Button.setTitleColor(.darkGray, for: .normal)
        p2Button.isEnabled = true
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        gameStatus = .Paused
    }
    
    @objc func timerInterrupt(_ timer: Timer) {
        let nowTime = totalSec - count
        
        switch  nowTime {
        case 11,21,31:/*１０秒前、２０秒前、３０秒前*/
            soundEffect(resource: "poon", ext: "mp3")
            countDown()
        case (5...10):/*９秒前〜４秒前*/
            soundEffect(resource: "pi", ext: "mp3")
            countDown()
        case 4:/*３秒前*/
            soundEffect(resource: "pooon", ext: "mp3")
            countDown()
        case 1:/*時間切れ*/
            timer.invalidate()
            audioPlayer?.stop()
            switch nowTurn {
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
    
    func soundEffect(resource: String, ext: String) {
        if let soundURL = Bundle.main.url(forResource: resource, withExtension: ext) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("soundEffectでエラー")
            }
        }
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
