//
//  ContentView.swift
//  Bob
//
//  Created by Aviral Garg on 2024-03-02.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        // function call to get detail view
                        getDetailView(item: item)
                    } label: {
                        Text(item.name)
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
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func getDetailView(item: Item) -> some View {
        HStack {
            VStack {
                Text("Item ID: \(item.item_id)")
                Text("Name: \(item.name)")
            }
            Spacer()
            VStack {
                Button("Update") {
                    withAnimation {
                        item.name = "Updated \(item.name)"
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }

    private func addItem() {
        withAnimation {
            // var nextItem = items.count  // issue: when deleting non-last items, the next item will have a duplicate id
            let nextItem = (items.map(\.item_id).max() ?? 0) + 1
            let newItem = Item(item_id: nextItem)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

// QnA:
// 1: how to delete items in macOS?
//   - use the delete key
//     - How to implement delete key in macOS?
//       - use onDelete(perform: deleteItems) in List on line 20
