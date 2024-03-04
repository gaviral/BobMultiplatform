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
    var node_id: Int
    var val: String
    var children: [Item]
    var my_depth: Int
    var my_index_at_my_depth: Int
    var parent: Item?

    // static var to keep track of tree depth
    static var max_depth = 0
    
    init(node_id: Int, my_depth: Int, my_index_at_my_depth: Int, parent: Item?, children: [Item]) {
        self.node_id = node_id
        self.val = "Item \(node_id)"
        self.my_depth = my_depth

        // update max_depth
        if my_depth > Item.max_depth {
            Item.max_depth = my_depth
        }

        self.my_index_at_my_depth = my_index_at_my_depth

        self.parent = parent

        self.children = children
    }

}
