//
//  P1SettingViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/03/25.
//

import UIKit

class P1PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var p1PickerView: UIPickerView!
    
    let dataList = [[Int](0...10), [Int](0...60), [Int](0...60)]
    let settings = UserDefaults.standard
    let p1TimeKey = "p1TimeKey"
    
    var hour = 0
    var min = 0
    var sec = 0
    var totalSec = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        p1PickerView.delegate = self
        p1PickerView.dataSource = self
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
        settings.setValue(totalSec, forKey: p1TimeKey)
        settings.synchronize()
    }
}
