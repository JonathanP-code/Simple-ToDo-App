import SwiftUI

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] {
        didSet {
            saveTasks()
        }
    }
    
    let tasksKey = "tasksKey"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        } else {
            tasks = []
        }
    }
    
    func addTask(title: String) {
        let newTask = Task(title: title)
        tasks.append(newTask)
    }
    
    func removeTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("")
                    .italic()
                    .bold()
                    .font(.system(size: 50, weight: .medium))
                    .padding(CGFloat.zero)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack {
                    TextField("", text: $newTaskTitle)
                        .hoverEffect(.highlight)
                        .padding()
                        .background(Color.black.opacity(1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.yellow, lineWidth: 3)
                        )
                        .foregroundColor(.white)
                    
                    Button(action: addTask) {
                        Image(systemName: "plus.app.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.tasks) { task in
                            HStack {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .black)
                                    .onTapGesture {
                                        viewModel.toggleTaskCompletion(task)
                                    }
                                
                                Text(task.title)
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .medium))
                                    .strikethrough(task.isCompleted, color: .white)
                                
                                Spacer()
                                
                                Button(action: {
                                    if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                        viewModel.removeTask(at: IndexSet(integer: index))
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity)
            }
            .padding(.top, 20)
        }
        .tabItem {
            Image(systemName: "list.bullet")
            Text("Tasks")
        }
    }
    
    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        viewModel.addTask(title: newTaskTitle)
        newTaskTitle = ""
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



@main
struct ToDoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
