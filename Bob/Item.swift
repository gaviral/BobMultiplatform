//
//  Item.swift
//  Bob
//
//  Created by Aviral Garg on 2024-03-02.
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
