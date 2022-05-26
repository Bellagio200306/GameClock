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
        adjastPicker(player)
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
    
//    UserDefaultsの時間をピッカーで表示
    func adjastPicker(_ player: Player) {
        
        switch player {
        case .P1: totalSec = userDefaults.integer(forKey: p1TimeKey)
        case .P2: totalSec = userDefaults.integer(forKey: p2TimeKey)
        }
        
        let h = totalSec / 3600
        let m = totalSec % 3600 / 60
        let s = totalSec % 3600 % 60
        
// ピッカーにセットされた初期値を保持（これをしないと「00:00:01」を「00:01:01」に変更した時「00:01:00」と表示されてしまう）
        hour = h
        min = m
        sec = s
        
        for component in 0..<dataList.count {
            switch component {
            case 0: pickerView.selectRow(h, inComponent: 0, animated: true)
            case 1: pickerView.selectRow(m, inComponent: 1, animated: true)
            case 2: pickerView.selectRow(s, inComponent: 2, animated: true)
            default: print("adjastPickerエラー")
            }
        }
    }
}
