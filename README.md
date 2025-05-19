# Todo App

A simple Todo application built with Swift and SwiftUI to demonstrate basic iOS development concepts.

## Features

- Create, read, update, and delete todo items
- Mark todos as completed
- Add due dates to todos
- Add notes to todos
- Persistence of todo items between app launches

## Swift Concepts Demonstrated

- SwiftUI for building the user interface
- State management with @State, @Binding, and @EnvironmentObject
- Data persistence with the Codable protocol and FileManager
- Navigation with NavigationStack and NavigationLink
- Presenting sheets and forms
- Swift structs, classes, and property wrappers

## How to Run the Project

1. Open the project in Xcode by double-clicking the `TodoApp.xcodeproj` file
2. Select a simulator device or connect your physical iOS device
3. Press the "Run" button (▶️) in Xcode or use the keyboard shortcut (Cmd+R)

## Project Structure

- **ToDoApp.swift**: The main entry point of the application
- **ContentView.swift**: The main screen showing the list of todos
- **TodoManager.swift**: Manages the todo data model and persistence
- **AddTodoView.swift**: Form for adding new todos
- **TodoDetailView.swift**: View for displaying and editing todo details

## Learning Resources

- [Apple's SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Swift Programming Language Guide](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)
- [Apple's Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) 