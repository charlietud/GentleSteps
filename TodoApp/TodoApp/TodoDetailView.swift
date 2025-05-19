import SwiftUI

// View to display and edit the details of a todo item
struct TodoDetailView: View {
    // Access the shared TodoManager
    @EnvironmentObject var todoManager: TodoManager
    
    // The todo item to display/edit
    let todo: TodoItem
    
    // State to track if we're in edit mode
    @State private var isEditing = false
    
    // State for edited values
    @State private var editedTitle: String = ""
    @State private var editedNotes: String = ""
    @State private var hasDueDate: Bool = false
    @State private var editedDueDate: Date = Date()
    
    // Dismiss action for the sheet
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // Title section
                Section(header: Text("Title")) {
                    if isEditing {
                        TextField("Title", text: $editedTitle)
                    } else {
                        Text(todo.title)
                            .font(.headline)
                    }
                }
                
                // Completion status section
                Section {
                    Toggle("Completed", isOn: Binding(
                        get: { todo.isCompleted },
                        set: { newValue in
                            if let index = todoManager.todos.firstIndex(where: { $0.id == todo.id }) {
                                todoManager.todos[index].isCompleted = newValue
                            }
                        }
                    ))
                }
                
                // Due date section
                Section(header: Text("Due Date")) {
                    if isEditing {
                        Toggle("Has Due Date", isOn: $hasDueDate)
                        
                        if hasDueDate {
                            DatePicker(
                                "Due Date",
                                selection: $editedDueDate,
                                displayedComponents: [.date]
                            )
                        }
                    } else if let dueDate = todo.dueDate {
                        Text(dueDate, style: .date)
                    } else {
                        Text("No due date")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                
                // Notes section
                Section(header: Text("Notes")) {
                    if isEditing {
                        TextEditor(text: $editedNotes)
                            .frame(minHeight: 150)
                    } else if !todo.notes.isEmpty {
                        Text(todo.notes)
                    } else {
                        Text("No notes")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                
                // Delete button (only shown when not editing)
                if !isEditing {
                    Section {
                        Button("Delete Todo", role: .destructive) {
                            if let index = todoManager.todos.firstIndex(where: { $0.id == todo.id }) {
                                todoManager.deleteTodo(at: IndexSet(integer: index))
                                dismiss()
                            }
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Todo" : "Todo Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            saveTodo()
                        } else {
                            // Start editing mode
                            editedTitle = todo.title
                            editedNotes = todo.notes
                            hasDueDate = todo.dueDate != nil
                            if let dueDate = todo.dueDate {
                                editedDueDate = dueDate
                            }
                        }
                        isEditing.toggle()
                    }
                }
                
                if isEditing {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isEditing = false
                        }
                    }
                }
            }
        }
    }
    
    // Save the edited todo
    private func saveTodo() {
        if let index = todoManager.todos.firstIndex(where: { $0.id == todo.id }) {
            todoManager.todos[index].title = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            todoManager.todos[index].notes = editedNotes.trimmingCharacters(in: .whitespacesAndNewlines)
            todoManager.todos[index].dueDate = hasDueDate ? editedDueDate : nil
        }
    }
}

// Preview for SwiftUI canvas
#Preview {
    let todoManager = TodoManager()
    let sampleTodo = TodoItem(title: "Sample Todo", notes: "This is a sample note")
    todoManager.todos.append(sampleTodo)
    
    return TodoDetailView(todo: sampleTodo)
        .environmentObject(todoManager)
} 