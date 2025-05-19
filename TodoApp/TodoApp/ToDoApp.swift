import SwiftUI

// Main entry point for the ToDo application
@main
struct ToDoApp: App {
    // State object to store and manage todo items
    @StateObject private var todoManager = TodoManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(todoManager)
        }
    }
} 