//
//  SettingsModel.swift
//  TikTokClone
//
//  Created by Caleb Ngai on 6/21/22.
//

import Foundation

struct SettingsSection {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let handler: (() -> Void)
}
