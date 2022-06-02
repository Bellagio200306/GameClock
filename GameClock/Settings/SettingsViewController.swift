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
    var observedP1: NSKeyValueObservation?
    var observedP2: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .gray
        loadData()
        
        observedP1 = userDefaults.observe(\.p1TimeKey, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            let newValue = change.newValue!
            self!.settings[0] = Setting(item: "Player 1", rightDetail: convertHMS(newValue))
            self!.tableView.reloadData()
        })
        
        observedP2 = userDefaults.observe(\.p2TimeKey, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            let newValue = change.newValue!
            self!.settings[1] = Setting(item: "Player 2", rightDetail: convertHMS(newValue))
            self!.tableView.reloadData()
        })
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

