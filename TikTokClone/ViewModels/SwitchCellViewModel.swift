//
//  File.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/21/22.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool

    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
