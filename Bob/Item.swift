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
    var item_id: Int = 0
    var name: String = ""
    
    init(item_id: Int) {
        self.item_id = item_id
        self.name = "Item \(item_id)"
    }

}
