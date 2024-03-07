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

    var body: some View {
        if !item.children.isEmpty {
            VStack(alignment: .leading) {
                ForEach(item.children) { node in
                    HStack {
                        Text("\(node.val)")
                        Button(action: {
                            let newChild = Item(my_depth: node.my_depth + 1, parent: node, children: [])
                            node.children.append(newChild)
                        }) {
                            Label("Add Child", systemImage: "plus")
                        }
                        Spacer().frame(width: indentMultiplier * CGFloat(item.my_depth)) // Indent based on depth
                        RecursiveTreeView(item: node, indentMultiplier: indentMultiplier)
                    }.padding(5).border(Color.red, width: 1).cornerRadius(10).padding(5)                    
                }
                .id(\Item.id) // Identify each child view uniquely
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
                                        Text("Root \(root.val)")
                                        Button(action: {
                                            let newChild = Item(my_depth: root.my_depth + 1, parent: root, children: [])
                                            root.children.append(newChild)
                                        }) {
                                            Label("Add Child", systemImage: "plus")
                                        }
                                    }.frame(minWidth: 0, alignment: .leading).border(Color.blue)
                                    RecursiveTreeView(item: root, indentMultiplier: 20)
                                }
                            }
                        }
                    } label: {
                        Text("Root \(root.val)")
                    }
                }
                .onDelete(perform: deleteItems)
                .id(\Item.id) // Identify each root view uniquely
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
            }
        } detail: {
            Text("Select an root")
        }
    }


    private func addRoot() {
        withAnimation {
            let root_depth = 0
            let newRoot = Item(my_depth: root_depth, parent: nil, children: [])
            let dummyChildren = (0..<300).map { i in
                Item(my_depth: root_depth + 1, parent: newRoot, children: [])
            }
            let dummyGrandChildren_1 = (0..<3).map { i in
                Item(my_depth: root_depth + 2, parent: dummyChildren[0], children: [])
            }
            let dummyGrandChildren_2 = (0..<3).map { i in
                Item(my_depth: root_depth + 2, parent: dummyChildren[1], children: [])
            }
            let dummyGrandChildren_3 = (0..<3).map { i in
                Item(my_depth: root_depth + 2, parent: dummyChildren[2], children: [])
            }
            
            // add only 2 children to the first root's first child's first child
            let dummyGrandChildren_1_1 = (0..<2).map { i in
                Item(my_depth: root_depth + 3, parent: dummyGrandChildren_1[0], children: [])
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
