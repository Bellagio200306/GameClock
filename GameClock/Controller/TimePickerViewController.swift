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
    private var currentRow = 0
    private let us = UserDefaults.standard
    let playerTimes = [[Int](0...9),
                       [0,1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60],
                       [0,1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,50,60],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        setTitle(player, pickerStatus)
        adjustPicker(player, pickerStatus)
        us.register(defaults: [p1hourRowKey: 0])
        us.register(defaults: [p1minRowKey: 0])
        us.register(defaults: [p1secRowKey: 0])
        us.register(defaults: [p2hourRowKey: 0])
        us.register(defaults: [p2minRowKey: 0])
        us.register(defaults: [p2secRowKey: 0])
        us.register(defaults: [fischerRowKey : 0])
    }
    
    private func setTitle(_ player: Player, _ pickerStatus: PickerStatus) {
        switch pickerStatus {
        case .PlayerTime:
            switch player {
            case .P1: pickerTitle.text = "Player 1 Time"
            case .P2: pickerTitle.text = "Player 2 Time"
            }
        case .FischerTime:
            pickerTitle.text = "Fischer Time"
        }
    }
    
    private func adjustPicker(_ player: Player, _ pickerStatus: PickerStatus) {
        switch pickerStatus {
        case .PlayerTime:
            var h: Int
            var m: Int
            var s: Int
            switch player {
            case .P1:
                h = us.integer(forKey: p1hourRowKey)
                m = us.integer(forKey: p1minRowKey)
                s = us.integer(forKey: p1secRowKey)
            case .P2:
                h = us.integer(forKey: p2hourRowKey)
                m = us.integer(forKey: p2minRowKey)
                s = us.integer(forKey: p2secRowKey)
            }
            
            for component in 0..<playerTimes.count {
                switch component {
                case 0: picker.selectRow(h, inComponent: component, animated: true)
                case 1: picker.selectRow(m, inComponent: component, animated: true)
                case 2: picker.selectRow(s, inComponent: component, animated: true)
                default: print("adjustPickerエラー")
                }
            }
        case .FischerTime:
            let row = us.integer(forKey: fischerRowKey)
            picker.selectRow(row, inComponent: 0, animated: true)
        }
        
    }
}

// MARK: - PickerView Delegate
extension TimePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerStatus {
        case .PlayerTime: return playerTimes.count
        case .FischerTime: return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerStatus {
        case .PlayerTime: return playerTimes[component].count
        case .FischerTime: return fischerTimes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerStatus {
        case .PlayerTime: return String(playerTimes[component][row])
        case .FischerTime: return String(fischerTimes[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerStatus {
        case .PlayerTime:
            switch player {
            case .P1:
                switch component {
                case 0:
                    hour = playerTimes[component][row]
                    us.set(row, forKey: p1hourRowKey)
                case 1:
                    min = playerTimes[component][row]
                    us.set(row, forKey: p1minRowKey)
                case 2:
                    sec = playerTimes[component][row]
                    us.set(row, forKey: p1secRowKey)
                default: print("pickerでエラー")
                }
            case .P2:
                switch component {
                case 0:
                    hour = playerTimes[component][row]
                    us.set(row, forKey: p2hourRowKey)
                case 1:
                    min = playerTimes[component][row]
                    us.set(row, forKey: p2minRowKey)
                case 2:
                    sec = playerTimes[component][row]
                    us.set(row, forKey: p2secRowKey)
                default: print("pickerでエラー")
                }
            }
            totalSec = hour * 60 * 60 + min * 60 + sec
            
            switch player {
            case .P1: us.set(totalSec, forKey: p1TimeKey)
            case .P2: us.set(totalSec, forKey: p2TimeKey)
            }
        case .FischerTime:
            us.set(row, forKey: fischerRowKey)
        }
        
    }
}

