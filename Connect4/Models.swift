//
//  Models.swift
//  Connect4
//
//  Created by 陳昕喬 on 2022/4/6.
//

import Foundation
import SwiftUI

struct CircleType: Identifiable{
    let id = UUID()
    var ownerIndex: Int = -1
    var color: Color = Color.clear
}

struct PlayerData {
    var name: String
    var color: Color
    var useChess: Int = 0
    var ownPlaceIndex: [Bool] = [Bool](repeating: false, count: 42)
    var history: [Int] = [Int](repeating: 0, count: 3)
}
