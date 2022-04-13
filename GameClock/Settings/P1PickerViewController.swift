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
    let p1TimeKey = "p1_time"
    
    var hour = 0
    var min = 0
    var sec = 0
    var totalSec = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let settings = UserDefaults.standard
//        let timerValue = settings.integer(forKey: p1TimeKey)
        p1PickerView.delegate = self
        p1PickerView.dataSource = self
        print(totalSec)
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
    
    
/*時、分、秒のピッカーから取得した値を秒に変換し足し合わせてUserDefaultsに保存したい
 hourなどに正しい値を入れられず困っています*/
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hour = dataList[0][row]
        min = dataList[1][row]
        sec = dataList[2][row]
        totalSec = hour * 60 * 60 + min * 60 + sec
        print(totalSec)
        
        let settings = UserDefaults.standard
        settings.setValue(totalSec, forKey: p1TimeKey)
        settings.synchronize()
    }
}
