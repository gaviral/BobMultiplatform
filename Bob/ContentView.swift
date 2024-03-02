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

                ToolbarItem {
                    Button(action: deleteAll) {
                        Label("Delete All", systemImage: "trash")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func getDetailView(item: Item) -> some View {
        VStack {
            Text(item.name)
            Spacer()
        }
    }

    private func addItem() {
        withAnimation {
            var nextItem = items.count
            let newItem = Item(item_id: nextItem)
            modelContext.insert(newItem)
        }
    }
    
    private func deleteAll() {
        deleteItems(offsets: IndexSet(items.indices))
        
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
