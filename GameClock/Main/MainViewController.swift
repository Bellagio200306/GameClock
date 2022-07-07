//
//  ViewController.swift
//  GameClock
//
//  Created by IpoAbe on 2022/01/31.
//

import UIKit

extension UserDefaults {
    @objc dynamic var p1TimeKey: Int {
        return integer(forKey: "p1TimeKey")
    }
    
    @objc dynamic var p2TimeKey: Int {
        return integer(forKey: "p2TimeKey")
    }
}

class MainViewController: UIViewController {
    
    @IBOutlet private weak var p1Button: UIButton!
    @IBOutlet private weak var p2Button: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!
    @IBOutlet private weak var settingButton: UIButton!
    
    private var mainModel = MainModel()
    private var player: Player = .P1
    private var gameStatus: GameStatus = .Paused
    private var observedP1: NSKeyValueObservation?
    private var observedP2: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p2Button.transform = mainModel.flipUpsideDown()
        setInitialState()
        
        userDefaults.register(defaults: [p1TimeKey : 60])
        observedP1 = userDefaults.observe(\.p1TimeKey, options: [.initial, .new], changeHandler: { (_, change) in
            if let changeValue = change.newValue {
                self.mainModel.totalSec = changeValue
            }
            self.p1Button.setTitle(self.mainModel.updateUserDefaults(), for: .normal)
        })
        
        userDefaults.register(defaults: [p2TimeKey : 60])
        observedP2 = userDefaults.observe(\.p2TimeKey, options: [.initial, .new], changeHandler: { (_, change) in
            if let changeValue = change.newValue {
                self.mainModel.totalSec = changeValue
            }
            self.p1Button.setTitle(self.mainModel.updateUserDefaults(), for: .normal)
        })
    }
    
    func setInitialState() {
        let p1Time = userDefaults.integer(forKey: p1TimeKey)
        let p2Time = userDefaults.integer(forKey: p2TimeKey)
        
        gameStatus = .Paused
        player = .P1
        
        changePauseImage(with: gameStatus)
        mainModel.setInitialTimer(setTotalSec: p1Time)
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
    
    @IBAction func p1ButtonPressed(_ sender: UIButton) {
        player = .P2
        playerButtonPressed(playingTurn: p2Button, breakTurn: p1Button)
    }
    
    @IBAction func p2ButtonPressed(_ sender: UIButton) {
        player = .P1
        playerButtonPressed(playingTurn: p1Button, breakTurn: p2Button)
    }
    
    func playerButtonPressed(playingTurn: UIButton, breakTurn: UIButton) {
        gameStatus = .Playing
        
        changePauseImage(with: gameStatus)
        mainModel.playSound(resource: "Move2", ext: "mp3")
        mainModel.resetCount()
        mainModel.setTotalSec(player)
        mainModel.startTimer(playingTurn)
        
        playingTurn.backgroundColor = UIColor(named: "PlayingTurnColor")
        playingTurn.setTitleColor(UIColor.white, for: .normal)
        playingTurn.isEnabled = true
        breakTurn.backgroundColor = UIColor(named: "BreakTurnColor")
        breakTurn.setTitleColor(UIColor.darkGray, for: .normal)
        breakTurn.isEnabled = false
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        switch gameStatus {
        case .Paused:
            gameStatus = .Playing
            p1Button.isEnabled = true
            p2Button.isEnabled = true
            mainModel.playSound(resource: "Move2", ext: "mp3")
            changePauseImage(with: gameStatus)
            
            switch player {
            case .P1:
                p1Button.backgroundColor = UIColor(named: "PlayingTurnColor")
                mainModel.startTimer(p1Button)
            case .P2:
                p2Button.backgroundColor = UIColor(named: "PlayingTurnColor")
                mainModel.startTimer(p2Button)
            }
            
        case .Playing:
            gameStatus = .Paused
            mainModel.stopTimer()
            p1Button.isEnabled = false
            p2Button.isEnabled = false
            mainModel.playSound(resource: "Pause", ext: "mp3")
            changePauseImage(with: gameStatus)
            
            switch player {
            case .P1: p1Button.backgroundColor = UIColor(named: "BreakTurnColor")
            case .P2: p2Button.backgroundColor = UIColor(named: "BreakTurnColor")
            }
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
        gameStatus = .Playing
        pauseButtonPressed(resetButton)
        let alert = UIAlertController(title: "リセットしますか？", message: nil, preferredStyle: .alert)
        let reset = UIAlertAction(title: "リセット", style: .destructive) {_ in
            self.setInitialState()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            self.dismiss(animated: true)
        }
        
        alert.addAction(reset)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        gameStatus = .Paused
        mainModel.stopTimer()
    }
}

