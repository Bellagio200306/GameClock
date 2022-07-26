//
//  SettingsViewController.swift
//  GameClock
//
//  Created by IpoAbe on 2022/04/08.
//
import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet private weak var p1Detail: UILabel!
    @IBOutlet private weak var p2Detail: UILabel!
    
    private var pickerView: UIPickerView?
    private var observedP1: NSKeyValueObservation?
    private var observedP2: NSKeyValueObservation?
    
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: 1)
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 1)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimePicker" {
            if let indexNum = tableView.indexPathForSelectedRow?.row {
                guard let destinationVC = segue.destination as? TimePickerViewController
                else {
                    fatalError("toPickerSegueでエラー")
                }
                switch indexNum {
                case 0: destinationVC.player = .P1
                case 1: destinationVC.player = .P2
                default: print("toPickerSegueでエラー")
                }
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
