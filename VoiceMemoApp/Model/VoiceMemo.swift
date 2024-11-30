//
//  VoiceMemo.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/11/30.
//

import Foundation

struct VoiceMemo {
    let id: String = UUID().uuidString
    let name: String
    let voice: String
    let voiceLength: Int
    let date: Date
    let place: String
    let Folder:[Folder]
    
    
}
