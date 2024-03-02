//
//  BobApp.swift
//  Bob
//
//  Created by Aviral Garg on 2024-03-02.
//

// Import the SwiftUI framework for UI components and SwiftData for data management.
import SwiftUI
import SwiftData

// Define a function to delete the existing store, if it exists. (TEMPORARY)
func deleteExistingStore() {
    // Assuming you know the URL or can construct it. This might vary based on how SwiftData stores its data.
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    guard let applicationSupportDirectoryUrl = urls.last else { return }
    let storeUrl = applicationSupportDirectoryUrl.appendingPathComponent("default.store")

    // Check if the file exists before attempting to delete it
    if fileManager.fileExists(atPath: storeUrl.path) {
        do {
            try fileManager.removeItem(at: storeUrl)
            print("Successfully deleted existing store")
        } catch {
            // Handle or log error
            print("Error deleting existing store: \(error)")
        }
    }
}


// Use the @main attribute to indicate the entry point of the app.
@main
struct BobApp: App {
    
    // Declare a sharedModelContainer property to hold the app's data model.
    var sharedModelContainer: ModelContainer = {
        // Call the store deletion logic here
        deleteExistingStore()
        
        // Define the schema for the model, listing all entity types.
        let schema = Schema([
            Item.self, // Add Item entity to the schema.
        ])
        // Configure the model, specifying the schema and storage option (persistent or in-memory).
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        // Attempt to create a ModelContainer with the given configuration.
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // If the model container cannot be created, crash the app with an error message.
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // Define the body of the app, which specifies the app's user interface.
    var body: some Scene {
        
        // Use WindowGroup to create a new window for the app's content.
        WindowGroup {
            ContentView() // Set ContentView as the root view of the app.
        }
        // Attach the sharedModelContainer to the WindowGroup, making it available throughout the app.
        .modelContainer(sharedModelContainer)
    }
}
