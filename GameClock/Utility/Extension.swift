//
//  Extension.swift
//  GameClock
//
//  Created by IpoAbe on 2022/07/11.
//

import UIKit

extension UserDefaults {
    @objc dynamic var p1TimeKey: Int {
        return integer(forKey: "p1TimeKey")
    }
    
    @objc dynamic var p2TimeKey: Int {
        return integer(forKey: "p2TimeKey")
    }
    
    @objc dynamic var timeModeKey: String {
        return string(forKey: "timeModeKey")!
    }
}

public extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

}
