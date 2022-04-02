//
//  SettingsTableViewController.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/03/05.
//

import UIKit

class SettingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    var settings: [Setting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .gray
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        loadData()
    }
    
    func loadData() {
        settings.append(Setting(item: "Player 1", rightDetail: "1:00"))
        settings.append(Setting(item: "Player 2", rightDetail: "2:00"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = settings[indexPath.row].item
        content.secondaryText = settings[indexPath.row].rightDetail
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    
    
}
