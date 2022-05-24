//
//  P1SettingViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/03/25.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let dataList = [[Int](0...10), [Int](0...60), [Int](0...60)]
    let userDefaults = UserDefaults.standard
    let p1TimeKey = "p1TimeKey"
    let p2TimeKey = "p2TimeKey"
    
    var hour = 0
    var min = 0
    var sec = 0
    var totalSec = 0
    var player: Player = .P1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(dataList[component][row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0: hour = row
        case 1: min = row
        case 2: sec = row
        default: print("pickerでエラー")
        }
        
        totalSec = hour * 60 * 60 + min * 60 + sec
        
        switch player {
        case .P1: userDefaults.set(totalSec, forKey: p1TimeKey)
        case .P2: userDefaults.set(totalSec, forKey: p2TimeKey)
        }
    }
}
