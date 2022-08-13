//
//  ViewController.swift
//  GameClock
//
//  Created by IpoAbe on 2022/01/31.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var p1Button: UIButton!
    @IBOutlet private weak var p2Button: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    
    private var mainModel = MainModel()
    private var player: Player = .P1
    private var gameStatus: GameStatus = .Paused
    private var timeMode: TimeMode = .Byoyomi
    private var timer = Timer()
    private var observedP1: NSKeyValueObservation?
    private var observedP2: NSKeyValueObservation?
    private var observedTimeMode: NSKeyValueObservation?
    private let us = UserDefaults.standard
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        p2Button.transform = mainModel.flipUpsideDown()
        setInitialState()
    }
    
    //MARK: - Functions
    private func setupView() {
        us.register(defaults: [p1TimeKey : 60])
        us.register(defaults: [p2TimeKey : 60])
        us.register(defaults: [timeModeKey : "byoyomi"])
        
        observedP1 = us.observe(\.p1TimeKey, options: [.initial, .new], changeHandler: { [weak self] _, change in
            if let changeValue = change.newValue {
                self?.mainModel.totalSec = changeValue
            }
            self?.p1Button.setTitle(self?.mainModel.updateUserDefaults(), for: .normal)
        })
        
        observedP2 = us.observe(\.p2TimeKey, options: [.initial, .new], changeHandler: {[weak self]  _, change in
            if let changeValue = change.newValue {
                self?.mainModel.totalSec = changeValue
            }
            self?.p2Button.setTitle(self?.mainModel.updateUserDefaults(), for: .normal)
        })
        
        observedTimeMode = us.observe(\.timeModeKey, options: [.initial, .new], changeHandler: {[weak self]  _, change in
            if let changeValue = change.newValue {
                switch changeValue {
                case "byoyomi": self?.timeMode = .Byoyomi
                case "kiremake": self?.timeMode = .Kiremake
                case "fischer": self?.timeMode = .Fischer
                default: print("observedTimeModeでエラー")
                }
            }
        })
    }
    
    private func setInitialState() {
        let p1Time = us.integer(forKey: p1TimeKey)
        let p2Time = us.integer(forKey: p2TimeKey)
        
        gameStatus = .Paused
        player = .P1
        
        timer.invalidate()
        pauseButton.setImage(UIImage(named: gameStatus.rawValue), for: .normal)
        mainModel.resetTime(player)
        pauseButton.isEnabled = true
        
        p1Button.setTitle(convertHMS(p1Time), for: .normal)
        p1Button.backgroundColor = UIColor(named: playingTurnColor)
        p1Button.setTitleColor(.white, for: .normal)
        p1Button.isEnabled = true
        
        p2Button.setTitle(convertHMS(p2Time), for: .normal)
        p2Button.backgroundColor = UIColor(named: breakTurnColor)
        p2Button.setTitleColor(.darkGray, for: .normal)
        p2Button.isEnabled = true
    }
    
    private func playerButtonPressed(_ senderTag: Int) {
        let isP1 = senderTag == 1
        let playingTurn = isP1 ? p2Button : p1Button
        let breakTurn = isP1 ? p1Button : p2Button
        
        player = isP1 ? .P2 : .P1
        gameStatus = .Playing
        switch timeMode {
        case .Byoyomi: mainModel.resetTime(player)
        case .Kiremake: mainModel.setPlayerTime(player)
        case .Fischer:
            mainModel.IncreasedFischerTime()
            mainModel.setPlayerTime(player)
        }
        pauseButton.setImage(UIImage(named: gameStatus.rawValue), for: .normal)
        mainModel.playSound(resource: seMove, ext: mp3)
        startTimer()
        updateUI()
        
        playingTurn?.backgroundColor = UIColor(named: playingTurnColor)
        playingTurn?.setTitleColor(UIColor.white, for: .normal)
        playingTurn?.isEnabled = true
        breakTurn?.backgroundColor = UIColor(named: breakTurnColor)
        breakTurn?.setTitleColor(UIColor.darkGray, for: .normal)
        breakTurn?.isEnabled = false
    }
    
    private func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerInterrupt(_:)), userInfo: nil, repeats: true)
    }
    
    private func countDown() {
        mainModel.count += 1
        updateUI()
    }
    
    private func updateUI() {
        let stringRemainCount = convertHMS(mainModel.timeRemaining())
        switch player {
        case .P1: p1Button.setTitle(stringRemainCount, for: .normal)
        case .P2: p2Button.setTitle(stringRemainCount, for: .normal)
        }
    }
    
    private func timeOut(_ player: UIButton) {
        player.isEnabled = false
        pauseButton.isEnabled = false
        player.setTitle("Lose.", for: .normal)
    }
    
    @objc private func timerInterrupt(_ timer: Timer) {
        switch  mainModel.timeRemaining() {
        case 11,21,31,61,181,301:/*10sec,20,30,1min,3,5*/
            mainModel.playSound(resource: sePoon, ext: mp3)
            countDown()
        case 5...10:/*4~9sec*/
            mainModel.playSound(resource: sePi, ext: mp3)
            countDown()
        case 4:/*3sec*/
            mainModel.playSound(resource: seBeep, ext: mp3)
            countDown()
        case 1:/*timeouts*/
            timer.invalidate()
            mainModel.audioPlayer?.stop()
            switch player {
            case .P1:
                timeOut(p1Button)
            case .P2:
                timeOut(p2Button)
            }
        default:
            countDown()
        }
    }
    
    //MARK: - Actions
    @IBAction private func reset(_ sender: UIButton) {
        gameStatus = .Playing
        pause(resetButton)
        let reset = UIAlertAction(title: "リセット", style: .destructive) {_ in
            self.setInitialState()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        showAlert(title: "リセットしますか？", message: "", actions: [reset, cancel])
    }
    
    @IBAction private func settings(_ sender: UIButton) {
        gameStatus = .Paused
        pauseButton.setImage(UIImage(named: gameStatus.rawValue), for: .normal)
        timer.invalidate()
    }
    
    @IBAction private func pause(_ sender: UIButton) {
        switch gameStatus {
        case .Paused:
            gameStatus = .Playing
            startTimer()
            p1Button.isEnabled = true
            p2Button.isEnabled = true
            mainModel.playSound(resource: seMove, ext: mp3)
            
            switch player {
            case .P1: p1Button.backgroundColor = UIColor(named: playingTurnColor)
            case .P2: p2Button.backgroundColor = UIColor(named: playingTurnColor)
            }
            
        case .Playing:
            gameStatus = .Paused
            timer.invalidate()
            p1Button.isEnabled = false
            p2Button.isEnabled = false
            mainModel.playSound(resource: sePause, ext: mp3)
            
            switch player {
            case .P1: p1Button.backgroundColor = UIColor(named: breakTurnColor)
            case .P2: p2Button.backgroundColor = UIColor(named: breakTurnColor)
            }
        }
        pauseButton.setImage(UIImage(named: gameStatus.rawValue), for: .normal)
    }
    
    @IBAction func switchPlayers(_ sender: UIButton) {
        playerButtonPressed(sender.tag)
    }
}

