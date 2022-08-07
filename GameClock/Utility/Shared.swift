//
//  Shared.swift
//  GameClock
//
//  Created by IpoAbe on 2022/05/31.
//

import Foundation
//MARK: - Enum
enum Player {
    case P1
    case P2
}

enum GameStatus: String {
    case Paused = "Playing"
    case Playing = "Paused"
}

enum TimeMode {
    case Byoyomi
    case Kiremake
    case Fischer
}

enum PickerStatus {
    case PlayerTime
    case FischerTime
}

//MARK: - Func
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

