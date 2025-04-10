# Task Logger

A minimalist Flutter application for tracking and logging daily repetitive tasks with a simple swipe interface. Perfect for habit tracking, daily routines, and recurring tasks.

## ✨ Features

- **Simple Swipe Interface**: Complete, skip, or mark tasks as failed with a single swipe gesture
- **Daily Task Dashboard**: View all your scheduled tasks for today at a glance
- **Weekly Schedule**: Configure tasks to repeat on specific days of the week
- **Task History**: Calendar view to track your task completion patterns over time
- **Clean, Minimal UI**: Distraction-free design focused on productivity
- **Quick Task Creation**: Create new tasks with title, description, and schedule in seconds


## 📱 Screenshots

<table>
  <tr>
    <td><img src="Screenshot 2025-04-09 195048.png" alt="Daily Tasks View" width="200"/></td>
    <td><img src="Screenshot 2025-04-09 195058.png" alt="Create Task Form" width="200"/></td>
    <td><img src="Screenshot 2025-04-09 195104.png" alt="Empty State" width="200"/></td>
  </tr>
  <tr>
    <td><img src="Screenshot 2025-04-09 195125.png" alt="History Calendar View" width="200"/></td>
    <td><img src="Screenshot 2025-04-09 195135.png" alt="All Tasks Completed" width="200"/></td>
  </tr>
</table>

## 🛠️ Technologies Used

- **Flutter**: UI framework for cross-platform development
- **Provider**: State management
- **Hive**: Local database for storing tasks
- **Flutter Calendar**: For the history view
- **Swipeable**: For the swipe gestures
- **Animations**: For smooth UI transitions

## 🚀 Getting Started

### Prerequisites

- Flutter (latest stable version)
- Dart
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/task-logger.git

# Navigate to the project directory
cd task-logger

# Get dependencies
flutter pub get

# Run the app in debug mode
flutter run
```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📖 How to Use

1. **Creating Tasks**:
   - Tap the "+" floating action button on the Tasks screen
   - Enter a title and optional description
   - Select which days of the week the task should appear
   - Tap "Create Task" to save

2. **Completing Tasks**:
   - On the Today screen, swipe right on a task to mark it as done
   - Swipe left to mark as failed
   - Swipe down to skip the task

3. **Viewing History**:
   - Navigate to the History tab to see your task completion calendar
   - Tap on a date to see detailed task statuses for that day

4. **Managing Tasks**:
   - Long press on a task to edit or delete it
   - Use the navigation bar to switch between Today, History, and Tasks views

## 🏗️ Project Structure

```
lib/
├── main.dart              # Entry point of the application
├── models/                # Data models
│   ├── task.dart
│   └── task_status.dart
├── screens/               # UI screens
│   ├── today_screen.dart
│   ├── create_task.dart
│   ├── history_screen.dart
│   └── tasks_screen.dart
├── providers/             # State management
│   └── task_provider.dart
├── services/              # Business logic
│   └── database_service.dart
└── widgets/               # Reusable UI components
    ├── task_card.dart
    └── day_selector.dart
```

## 🛡️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Contact

Your Name - Gautam Kumar - gk39951@gmail.com



---

*Made with ❤️ and Flutter*
