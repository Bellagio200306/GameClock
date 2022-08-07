//
//  SettingsViewController.swift
//  GameClock
//
//  Created by IpoAbe on 2022/04/08.
//
import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    private var observedP1: NSKeyValueObservation?
    private var observedP2: NSKeyValueObservation?
    @IBOutlet private weak var p1Detail: UILabel!
    @IBOutlet private weak var p2Detail: UILabel!
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Functions
    private func setupView() {
        self.navigationController?.navigationBar.tintColor = .gray
        
        observedP1 = userDefaults.observe(\.p1TimeKey, options: [.initial, .new], changeHandler: { [weak self] _, change in
            if let change = change.newValue {
                self?.p1Detail.text = convertHMS(change)
                self?.tableView.reloadData()
            }
        })
        
        observedP2 = userDefaults.observe(\.p2TimeKey, options: [.initial, .new], changeHandler: { [weak self] _, change in
            if let change = change.newValue {
                self?.p2Detail.text = convertHMS(change)
                self?.tableView.reloadData()
            }
        })
        
        let currentTimeMode = userDefaults.string(forKey: timeModeKey)
        var row: Int
        switch currentTimeMode {
        case "byoyomi": row = selectByoyomi
        case "kiremake": row = selectKiremake
        case "fischer": row = selectFischer
        default: return
        }
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 1)) else { return }
        cell.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0...sectionEndIndex {
            if let timeModeCell = tableView.cellForRow(at: IndexPath(row: row, section: timeModeSection)) {
                timeModeCell.accessoryType = row == indexPath.row ? .checkmark : .none
                switch indexPath.row {
                case selectByoyomi: userDefaults.set("byoyomi", forKey: timeModeKey)
                case selectKiremake: userDefaults.set("kiremake", forKey: timeModeKey)
                case selectFischer: userDefaults.set("fischer", forKey: timeModeKey)
                default: print("didSelectRowAtエラー")
                }
            }
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? TimePickerViewController else { return }
        if let sheet = destinationVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        if segue.identifier == "toTimePicker" {
            if let indexNum = tableView.indexPathForSelectedRow?.row {
                destinationVC.pickerStatus = .PlayerTime
                switch indexNum {
                case selectP1: destinationVC.player = .P1
                case selectP2: destinationVC.player = .P2
                default: print("toPickerSegueエラー")
                }
            }
        } else if segue.identifier == "toFischerPicker" {
            destinationVC.pickerStatus = .FischerTime
        }
    }
    
    //MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
