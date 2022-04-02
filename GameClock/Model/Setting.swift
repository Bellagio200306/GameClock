//
//  SettingsListSource.swift
//  GameClock
//
//  Created by 安部一歩 on 2022/03/25.
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

