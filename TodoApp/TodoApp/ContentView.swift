import SwiftUI

// Main view of the application that displays the list of todos
struct ContentView: View {
    // Access the shared TodoManager through the environment
    @EnvironmentObject var todoManager: TodoManager
    
    // State to control the new todo input field and sheet presentation
    @State private var newTodoTitle = ""
    @State private var showingAddTodoView = false
    
    var body: some View {
        NavigationStack {
            List {
                // Display the list of todos with swipe-to-delete functionality
                ForEach(todoManager.todos) { todo in
                    NavigationLink(destination: TodoDetailView(todo: todo)) {
                        TodoRowView(todo: todo)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            if let index = todoManager.todos.firstIndex(where: { $0.id == todo.id }) {
                                todoManager.deleteTodo(at: IndexSet(integer: index))
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete(perform: todoManager.deleteTodo)
                
                // Display a message when the list is empty
                if todoManager.todos.isEmpty {
                    Text("No todos yet! Add some using the + button")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                }
            }
            .navigationTitle("My Todo List")
            .toolbar {
                // Add button to create a new todo
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTodoView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView(isPresented: $showingAddTodoView)
            }
        }
    }
}

// Row view for a single todo item
struct TodoRowView: View {
    @EnvironmentObject var todoManager: TodoManager
    let todo: TodoItem
    
    var body: some View {
        HStack {
            // Checkbox button to toggle completion status
            Button {
                todoManager.toggleCompletion(for: todo)
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
            }
            
            // Todo title with strikethrough if completed
            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? .gray : .primary)
            
            Spacer()
            
            // Display the due date if available
            if let dueDate = todo.dueDate {
                Text(dueDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

// Preview for SwiftUI canvas
#Preview {
    ContentView()
        .environmentObject(TodoManager())
} 