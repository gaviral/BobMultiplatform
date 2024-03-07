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
    var id: UUID = UUID()
    var val: String
    var children: [Item]
    var my_depth: Int
    var parent: Item?

    // static var to keep track of tree depth
    static var max_depth = 0
    
    init(my_depth: Int, parent: Item?, children: [Item]) {
        self.val = "Item val"
        self.my_depth = my_depth

        // update max_depth
        if my_depth > Item.max_depth {
            Item.max_depth = my_depth
        }

        self.parent = parent

        self.children = children
    }

}
