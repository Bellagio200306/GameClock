//
//  SettingsViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/04/08.
//
import Foundation
import UIKit

protocol SettingsViewControllerDelegate {
    func viewDidDismiss()
}

class SettingsViewController: UITableViewController {
    
    var delegate: SettingsViewControllerDelegate?
    var settings: [Setting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .gray
        presentationController?.delegate = self
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func loadData() {
        settings.append(Setting(item: "Player 1", rightDetail: "1:00"))
        settings.append(Setting(item: "Player 2", rightDetail: "2:00"))
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = settings[indexPath.row].item
        content.secondaryText = settings[indexPath.row].rightDetail
        cell.contentConfiguration = content
        
        return cell
    }
}

extension SettingsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        print("\(type(of: self)): \(#function)")
        return true
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print("\(type(of: self)): \(#function)")
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("\(type(of: self)): \(#function)")
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("\(type(of: self)): \(#function)")
        delegate?.viewDidDismiss()
    }
}
