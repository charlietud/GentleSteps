import SwiftUI

// View for adding a new todo item
struct AddTodoView: View {
    // Access the shared TodoManager
    @EnvironmentObject var todoManager: TodoManager
    
    // Binding to control the presentation of this view
    @Binding var isPresented: Bool
    
    // State variables for todo details
    @State private var title = ""
    @State private var notes = ""
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                // Title field (required)
                Section(header: Text("Title")) {
                    TextField("Enter todo title", text: $title)
                }
                
                // Notes field (optional)
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
                
                // Due date section (optional)
                Section {
                    Toggle("Set Due Date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker(
                            "Due Date",
                            selection: $dueDate,
                            displayedComponents: [.date]
                        )
                    }
                }
            }
            .navigationTitle("Add New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                // Save button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addTodo()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    // Function to add the new todo and dismiss the view
    private func addTodo() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Only add if title is not empty
        if !trimmedTitle.isEmpty {
            todoManager.addTodo(
                title: trimmedTitle,
                notes: trimmedNotes,
                dueDate: hasDueDate ? dueDate : nil
            )
            isPresented = false
        }
    }
}

// Preview for SwiftUI canvas
#Preview {
    AddTodoView(isPresented: .constant(true))
        .environmentObject(TodoManager())
} 