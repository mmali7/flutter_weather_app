# Flutter Todo App

A modern, professional Todo application built with Flutter using Clean Architecture principles and best coding practices.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── di/                 # Dependency injection
│   └── theme/              # App theming
├── features/
│   └── todo/
│       ├── domain/         # Business logic layer
│       │   ├── entities/   # Business entities
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecases/   # Business use cases
│       ├── data/           # Data layer
│       │   ├── datasources/ # Data sources (local/remote)
│       │   ├── models/     # Data models
│       │   └── repositories/ # Repository implementations
│       └── presentation/   # Presentation layer
│           ├── bloc/       # State management
│           ├── pages/      # UI screens
│           └── widgets/    # UI components
└── l10n/                   # Localization
```

## 🚀 Features

### Core Features
- ✅ Create, read, update, and delete tasks
- ✅ Task categories (Personal, Work, Shopping, Health, Education, Other)
- ✅ Priority levels (Low, Medium, High)
- ✅ Due dates with overdue detection
- ✅ Task completion status with timestamps

### UI/UX Features
- ✅ Modern Material Design 3 interface
- ✅ Dark/Light theme support with system preference detection
- ✅ Smooth animations and transitions
- ✅ Responsive layout for different screen sizes
- ✅ Proper loading states and error handling
- ✅ Empty states with helpful messages

### Data & Search
- ✅ Local storage using Hive (SQLite alternative)
- ✅ Real-time search functionality
- ✅ Advanced filtering (All, Active, Completed, Overdue, Due Today)
- ✅ Data persistence across app sessions

### Additional Features
- ✅ Task statistics and progress tracking
- ✅ Comprehensive error handling and logging
- ✅ Localization support (ready for multiple languages)
- ✅ Accessibility features

## 🛠️ Technical Implementation

### State Management
- **BLoC Pattern** with `flutter_bloc` for predictable state management
- **Cubit** for simpler state management (theme preferences)

### Dependency Injection
- **GetIt** for service location
- **Injectable** for code generation and automatic registration

### Local Storage
- **Hive** for fast, lightweight local database
- Type-safe data models with code generation

### Code Quality
- **Clean Architecture** with clear layer separation
- **SOLID Principles** implementation
- **Repository Pattern** for data abstraction
- **Use Cases** for business logic encapsulation

### Testing Ready
- Comprehensive unit test structure
- BLoC testing with `bloc_test`
- Mock implementations with `mocktail`

## 📱 Screenshots

*Screenshots would be added here showing the app in action*

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.6)
- Dart SDK (>=3.0.6)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter_todo_app.git
   cd flutter_todo_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Generate code (watch mode)**
   ```bash
   flutter packages pub run build_runner watch
   ```

## 🧪 Testing

The app includes comprehensive testing:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/todo/domain/usecases/add_todo_test.dart
```

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc` - State management
- `get_it` & `injectable` - Dependency injection
- `hive` & `hive_flutter` - Local storage
- `equatable` - Value equality
- `uuid` - Unique ID generation

### UI Dependencies
- `google_fonts` - Typography
- `flutter_svg` - Vector graphics
- `lottie` - Animations

### Development Dependencies
- `build_runner` - Code generation
- `injectable_generator` - DI code generation
- `hive_generator` - Hive adapters
- `bloc_test` - BLoC testing
- `mocktail` - Mocking

## 🎨 Design System

The app uses a consistent design system with:

- **Typography**: Inter font family with proper hierarchy
- **Colors**: Material Design 3 color system
- **Spacing**: 8px grid system
- **Components**: Reusable UI components
- **Animations**: Smooth transitions and micro-interactions

## 🌐 Localization

The app is ready for internationalization:

1. Add new `.arb` files in `lib/l10n/`
2. Update `l10n.yaml` configuration
3. Run `flutter gen-l10n` to generate translations
4. Use `AppLocalizations.of(context)` in widgets

## 🚀 Performance

- **Lazy loading** of data and UI components
- **Efficient state management** with BLoC
- **Optimized builds** with proper widget separation
- **Memory management** with proper disposal patterns

## 🔮 Future Enhancements

- [ ] Cloud synchronization (Firebase/Supabase)
- [ ] Push notifications for reminders
- [ ] Task sharing and collaboration
- [ ] Advanced analytics and insights
- [ ] Widget support for quick task creation
- [ ] Voice input for task creation
- [ ] Task templates and recurring tasks

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Open source community for the excellent packages

---

**Built with ❤️ using Flutter and Clean Architecture**