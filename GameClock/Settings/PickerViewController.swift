//
//  P1SettingViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/03/25.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var PickerView: UIPickerView!
    
    let dataList = [[Int](0...10), [Int](0...60), [Int](0...60)]
    let userDefaults = UserDefaults.standard
    let p1TimeKey = "p1TimeKey"
    let p2TimeKey = "p2TimeKey"
    
    var hour = 0
    var min = 0
    var sec = 0
    var totalSec = 0
    var indexNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PickerView.delegate = self
        PickerView.dataSource = self
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
        case 0:
            hour = row
        case 1:
            min = row
        case 2:
            sec = row
        default:
            print("pickerでエラー")
        }
        
        totalSec = hour * 60 * 60 + min * 60 + sec
        
        switch indexNum {
        case 0:
            userDefaults.setValue(totalSec, forKey: p1TimeKey)
            print(userDefaults.integer(forKey: p1TimeKey))
            print(userDefaults.integer(forKey: p2TimeKey))
        case 1:
            userDefaults.setValue(totalSec, forKey: p2TimeKey)
            print(userDefaults.integer(forKey: p1TimeKey))
            print(userDefaults.integer(forKey: p2TimeKey))
        default:
            print("pickerでエラー")
        }
    }
}
