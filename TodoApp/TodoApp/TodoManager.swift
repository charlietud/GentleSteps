import Foundation

// Todo item model that contains all information for a single todo item
struct TodoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var notes: String = ""
}

// Manages the collection of todo items and provides methods to manipulate them
class TodoManager: ObservableObject {
    // Published property that triggers UI updates when the todos array changes
    @Published var todos: [TodoItem] = [] {
        didSet {
            saveTodos()
        }
    }
    
    // The file URL where todos will be saved
    private let saveKey = "TodoList"
    private var todosURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("\(saveKey).json")
    }
    
    init() {
        loadTodos()
    }
    
    // Add a new todo item to the list
    func addTodo(title: String, notes: String = "", dueDate: Date? = nil) {
        let newTodo = TodoItem(title: title, notes: notes, dueDate: dueDate)
        todos.append(newTodo)
    }
    
    // Delete a todo item from the list
    func deleteTodo(at indexSet: IndexSet) {
        todos.remove(atOffsets: indexSet)
    }
    
    // Toggle the completion status of a todo item
    func toggleCompletion(for todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
        }
    }
    
    // Save todos to persistent storage
    private func saveTodos() {
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: todosURL)
        } catch {
            print("Failed to save todos: \(error.localizedDescription)")
        }
    }
    
    // Load todos from persistent storage
    private func loadTodos() {
        guard let data = try? Data(contentsOf: todosURL) else { return }
        
        do {
            todos = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            print("Failed to load todos: \(error.localizedDescription)")
        }
    }
} 