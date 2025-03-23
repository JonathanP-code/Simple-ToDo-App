# ToDo App

A simple and elegant To-Do app built with **SwiftUI**, designed to help users efficiently manage their tasks. The app allows users to add, mark as complete, and delete tasks, with data persistence using **UserDefaults**.

---

## 📂 Project Overview

- **Platform:** iOS (SwiftUI)
- **Language:** Swift
- **Storage:** UserDefaults
- **Features:** Task creation, completion toggle, deletion, and data persistence.

---
<img src="https://github.com/user-attachments/assets/504df8f4-051d-499c-a8b6-628153f14194" width="200"> <img src="https://github.com/user-attachments/assets/ac0b8f2c-1b6d-4934-9fee-4dfc52aa27cf" width="200"> <img src="https://github.com/user-attachments/assets/86362f46-bc73-4ba7-b344-e394cd27a475" width="200">

---

## ✨ Features

✅ **Add New Tasks** – Easily add new tasks using the input field.  
✅ **Mark Tasks as Completed** – Tap the task icon to toggle completion.  
✅ **Delete Tasks** – Remove unwanted tasks with a trash button.  
✅ **Data Persistence** – Stores tasks locally using `UserDefaults`.  

---

## 📥 Installation

To set up the project locally, follow these steps:

### **1️⃣ Clone the Repository**
```sh
git clone https://github.com/your-username/todo-app.git
cd todo-app
```

### **2️⃣ Open in Xcode**
- Open `ToDoApp.xcodeproj` in **Xcode**.
- Select a target device (iPhone simulator or real device).

### **3️⃣ Run the App**
Click ▶️ **Run** in Xcode to launch the app.

---

## 🛠 Usage Guide

### **Adding a Task**
1. Enter a task title in the **text field**.
2. Press the ➕ **plus button** to add the task.

### **Marking a Task as Completed**
- Tap the **circle icon** to toggle completion status.
- Completed tasks will appear with a **checkmark**.

### **Deleting a Task**
- Tap the **trash icon** next to a task to remove it.

---

## Code Structure

### **Task Model** (`Task.swift`)
```swift
struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

```

### **ViewModel for Task Management** (`TaskViewModel.swift`)
```swift
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
```

### **Main View** (`ContentView.swift`)
```swift
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
```

---

## 🚀 Future Improvements
- ❌ **Cloud Syncing** (iCloud or Firebase for multi-device support)
- ✅ **Custom Themes** (Light & Dark Mode)
- ✅ **Deadline & Notifications** (Reminders for tasks)
- ✅ **Drag & Drop Sorting** (Rearrange tasks dynamically)

---

## License
This project is open-source under the **MIT License**.

---

## Contributing
Contributions are welcome! If you find a bug or have suggestions, feel free to open an **issue** or submit a **pull request**.

---

## 🌟 Show Your Support
If you like this project, please ⭐ star the repository on GitHub!



