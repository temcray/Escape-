//
//  Item.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
