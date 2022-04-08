//
//  P1SettingViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/03/25.
//

import UIKit

class P1PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var p1PickerView: UIPickerView!
    
    let dataList = [Int](0...60)
    let p1TimeKey = "p1_time"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = UserDefaults.standard
        let timerValue = settings.integer(forKey: p1TimeKey)
        p1PickerView.delegate = self
        p1PickerView.dataSource = self
        
        for row in 0..<dataList.count {
            if dataList[row] == timerValue {
                p1PickerView.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(dataList[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let settings = UserDefaults.standard
        settings.setValue(dataList[row], forKey: p1TimeKey)
        settings.synchronize()
    }
}
