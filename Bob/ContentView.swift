//
//  ContentView.swift
//  Bob
//
//  Created by Aviral Garg on 2024-03-02.
//

import SwiftUI
import SwiftData

struct RecursiveTreeView: View {

    let item: Item
    let indentMultiplier: CGFloat
    let refresh: () -> Void

    var body: some View {
        if !item.children.isEmpty {
            VStack(alignment: .leading) {
                ForEach(item.children) { node in            
                    HStack {
                        Text("Node \(node.node_id)")
                        // Text("Parent \(node.parent?.node_id ?? -1)")
                        Button(action: {
                            withAnimation {
                                let my_next_child_id = node.node_id*10 + node.children.count
                                let newChild = Item(node_id: my_next_child_id, my_depth: node.my_depth + 1, parent: node, children: [])
                                node.children.append(newChild)
                            }
                        }) {
                            Label("Add Child", systemImage: "plus")
                        }
                        Spacer().frame(width: indentMultiplier * CGFloat(item.my_depth)) // Indent based on depth
                        RecursiveTreeView(item: node, indentMultiplier: indentMultiplier, refresh: refresh)
                    }.padding(5).border(Color.red, width: 1).cornerRadius(10).padding(5)                    
                }
            }.padding()
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var nodes: [Item]

    var roots: [Item] {
        nodes.filter { $0.parent == nil }
    }

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(roots) { root in
                    NavigationLink {
                        ScrollView(.horizontal) {
                            ScrollView(.vertical) {
                                HStack {
                                    VStack {
                                        Text("Node \(root.node_id)")
                                        // Text("Parent \(root.parent?.node_id ?? -1)")
                                        // Make this VStack's width equal to the width of the text in it
                                    }.frame(minWidth: 0, alignment: .leading).border(Color.blue)
                                    RecursiveTreeView(item: root, indentMultiplier: 20, refresh: refresh)
                                }
                            }
                        }
                    } label: {
                        Text("Root \(root.node_id)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addRoot) {
                        Label("Add Root", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: refresh) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
        } detail: {
            Text("Select an root")
        }
    }

    private func refresh() {
        withAnimation {
            modelContext.processPendingChanges()
        }
    }


    private func addRoot() {
        withAnimation {
            let nextRootID = (roots.map(\.node_id).max() ?? 0) + 1
            let root_depth = 0
            let newRoot = Item(node_id: nextRootID, my_depth: root_depth, parent: nil, children: [])
            let child_id = nextRootID
            let dummyChildren = (0..<3).map { i in
                Item(node_id: child_id*10 + i, my_depth: root_depth + 1, parent: newRoot, children: [])
            }
            let dummyGrandChildren_1 = (0..<3).map { i in
                Item(node_id: (dummyChildren[0].node_id)*10 + i, my_depth: root_depth + 2, parent: dummyChildren[0], children: [])
            }
            let dummyGrandChildren_2 = (0..<3).map { i in
                Item(node_id: (dummyChildren[1].node_id)*10 + i, my_depth: root_depth + 2, parent: dummyChildren[1], children: [])
            }
            let dummyGrandChildren_3 = (0..<3).map { i in
                Item(node_id: (dummyChildren[2].node_id)*10 + i, my_depth: root_depth + 2, parent: dummyChildren[2], children: [])
            }
            
            // add only 2 children to the first root's first child's first child
            let dummyGrandChildren_1_1 = (0..<2).map { i in
                Item(node_id: (dummyGrandChildren_1[0].node_id)*10 + i, my_depth: root_depth + 3, parent: dummyGrandChildren_1[0], children: [])
            }
            dummyGrandChildren_1[0].children = dummyGrandChildren_1_1
            
            dummyChildren[0].children = dummyGrandChildren_1
            dummyChildren[1].children = dummyGrandChildren_2
            dummyChildren[2].children = dummyGrandChildren_3
            newRoot.children = dummyChildren
            modelContext.insert(newRoot)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(roots[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
