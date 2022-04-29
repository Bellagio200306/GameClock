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
    let p1TimeKey = "p1_time"
    
    var hour = 0
    var min = 0
    var sec = 0
    var totalSec = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let timerValue = settings.integer(forKey: p1TimeKey)
        settings.register(defaults: ["hour": 0])
        settings.register(defaults: ["min": 0])
        settings.register(defaults: ["sec": 0])
        p1PickerView.delegate = self
        p1PickerView.dataSource = self
        //        for row in 0..<dataList.count {
        //            if dataList[row] == timerValue {
        //                p1PickerView.selectRow(row, inComponent: 0, animated: true)
        //            }
        //        }
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
            settings.setValue(hour, forKey: "hour")
            settings.synchronize()
            
        case 1:
            min = row
            settings.setValue(min, forKey: "min")
            settings.synchronize()
            
        case 2:
            sec = row
            settings.setValue(sec, forKey: "sec")
            settings.synchronize()
        default:
            print("pickerでエラー")
        }
    }
}
