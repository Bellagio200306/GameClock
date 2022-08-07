//
//  TimePickerViewController.swift
//  GameClock
//
//  Created by IpoAbe on 2022/03/25.
//

import UIKit

class TimePickerViewController: UIViewController {
    @IBOutlet private weak var picker: UIPickerView!
    @IBOutlet weak var pickerTitle: UILabel!
    
    var pickerStatus: PickerStatus = .PlayerTime
    var player: Player = .P1
    private var hour = 0
    private var min = 0
    private var sec = 0
    private var totalSec = 0
    
    let playerTimes = [[Int](0...9),[Int](0...59),[Int](0...59)]
    let fischerTimes = [[Int](0...60)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        setTitle(player, pickerStatus)
        adjustPicker(player, pickerStatus)
    }

    private func setTitle(_ player: Player, _ pickerStatus: PickerStatus) {
        switch pickerStatus {
        case .PlayerTime:
            switch player {
            case .P1: pickerTitle.text = "Player 1"
            case .P2: pickerTitle.text = "Player 2"
            }
        case .FischerTime:
            pickerTitle.text = "FISCHER TIME"
        }
    }
    
    private func adjustPicker(_ player: Player, _ pickerStatus: PickerStatus) {
        switch pickerStatus {
        case .PlayerTime:
            switch player {
            case .P1: totalSec = userDefaults.integer(forKey: p1TimeKey)
            case .P2: totalSec = userDefaults.integer(forKey: p2TimeKey)
            }
            
            let h = totalSec / 3600
            let m = totalSec % 3600 / 60
            let s = totalSec % 3600 % 60
            
            hour = h
            min = m
            sec = s
            
            for component in 0..<playerTimes.count {
                switch component {
                case 0: picker.selectRow(h, inComponent: component, animated: true)
                case 1: picker.selectRow(m, inComponent: component, animated: true)
                case 2: picker.selectRow(s, inComponent: component, animated: true)
                default: print("adjustPickerエラー")
                }
            }
        case .FischerTime:
            sec = userDefaults.integer(forKey: fischerTimeKey)
            picker.selectRow(fischerTimes[0][sec], inComponent: 0, animated: true)
        }
        
    }
}

// MARK: - PickerView Delegate
extension TimePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerStatus {
        case .PlayerTime: return playerTimes.count
        case .FischerTime: return fischerTimes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerStatus {
        case .PlayerTime: return playerTimes[component].count
        case .FischerTime: return fischerTimes[component].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerStatus {
        case .PlayerTime: return String(playerTimes[component][row])
        case .FischerTime: return String(fischerTimes[component][row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerStatus {
        case .PlayerTime:
            switch component {
            case 0: hour = playerTimes[component][row]
            case 1: min = playerTimes[component][row]
            case 2: sec = playerTimes[component][row]
            default: print("pickerでエラー")
            }
            
            totalSec = hour * 60 * 60 + min * 60 + sec
            
            switch player {
            case .P1: userDefaults.set(totalSec, forKey: p1TimeKey)
            case .P2: userDefaults.set(totalSec, forKey: p2TimeKey)
            }
        case .FischerTime:
            sec = fischerTimes[component][row]
            userDefaults.set(sec, forKey: fischerTimeKey)
        }
        
    }
}

