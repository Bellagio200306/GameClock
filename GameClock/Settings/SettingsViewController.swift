//
//  SettingsViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/04/08.
//
import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    var settings: [Setting] = []
    
    let userDefaults = UserDefaults.standard
    let p1TimeKey = "p1TimeKey"
    let p2TimeKey = "p2TimeKey"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .gray
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func loadData() {
        let p1Time = userDefaults.integer(forKey: p1TimeKey)
        let p2Time = userDefaults.integer(forKey: p2TimeKey)
        settings.append(Setting(item: "Player 1", rightDetail: convertHMS(p1Time)))
        settings.append(Setting(item: "Player 2", rightDetail: convertHMS(p2Time)))
    }
    
    func convertHMS(_ time: Int) -> String {
        var stringTime = "00:00:00"
        let hour = time / 3600
        let min = time % 3600 / 60
        let sec = time % 3600 % 60
        
        let stringHour = String(hour)
        let stringMin = String(format: "%02d", min)
        let stringSec = String(format: "%02d", sec)
        
        switch time {
        case (0..<60): stringTime = "\(stringSec)"
        case (60..<3600): stringTime = "\(stringMin):\(stringSec)"
        default : stringTime = "\(stringHour):\(stringMin):\(stringSec)"
        }
        return stringTime
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = settings[indexPath.row].item
        content.secondaryText = settings[indexPath.row].rightDetail
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPicker" {
            if let indexNum = tableView.indexPathForSelectedRow?.row {
                guard let destinationVC = segue.destination as? PickerViewController
                else {
                    fatalError("Failed to prepare DetailViewController.")
                }
                switch indexNum {
                case 0: destinationVC.player = .P1
                case 1: destinationVC.player = .P2
                default: print("toPickerSegueでエラー")
                }
            }
        }
    }
}

