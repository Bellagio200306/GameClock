//
//  FischerPickerViewController.swift
//  GameClock
//
//  Created by IpoAbe on 2022/08/04.
//

import UIKit

class FischerPickerViewController: UIViewController {
    @IBOutlet private weak var picker: UIPickerView!
    let times = [[Int](0...60)]
    var sec = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        adjustPicker()
    }
    
    private func adjustPicker() {
        sec = userDefaults.integer(forKey: fischerTimeKey)
        picker.selectRow(times[0][sec], inComponent: 0, animated: true)
    }
}

// MARK: - PickerView Delegate
extension FischerPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(times[component][row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sec = times[component][row]
        userDefaults.set(sec, forKey: fischerTimeKey)
    }
}


