//
//  SettingsListSource.swift
//  GameClock
//
//  Created by IpoAbe on 2022/03/25.
//

import Foundation

struct Setting {
    private(set) public var item: String
    private(set) public var rightDetail: String
    
    init(item: String, rightDetail: String) {
        self.item = item
        self.rightDetail = rightDetail
    }
}

