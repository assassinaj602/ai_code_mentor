# 🤖 AI Code Mentor

<p align="center">
  <img src="assets/logo.jpg" alt="AI Code Mentor logo" width="200"/>
</p>

A comprehensive Flutter mobile app that provides AI-powered code analysis, debugging, and mentoring using the OpenRouter LLM API.

## 📱 Features

### ✅ Implemented Core Features

- **Multiple Input Methods**
  - ✅ Paste code directly
  - ✅ Upload screenshots of code
  - ✅ Paste error logs
  
- **AI-Powered Analysis**
  - ✅ Automatic programming language detection
  - ✅ Root cause identification
  - ✅ Fixed code generation
  - ✅ Multi-level explanations (Beginner/Intermediate/Expert)
  - ✅ Best practices recommendations
  - ✅ Alternative solutions

- **Code Diff Viewer**
  - ✅ Side-by-side comparison
  - ✅ Syntax highlighting
  - ✅ Color-coded differences (additions, removals, changes)

- **Analysis History**
  - ✅ Local storage using SharedPreferences
  - ✅ Timestamp tracking
  - ✅ Quick access to previous analyses

- **Modern UI/UX**
  - ✅ Material Design 3
  - ✅ Dark/Light theme support
  - ✅ Responsive layout
  - ✅ Clean, intuitive navigation

## 🏗️ Architecture

The app follows **Clean Architecture** principles with separation of concerns:

```
lib/
├── core/                      # Core utilities and services
│   ├── api/
│   │   └── openrouter_service.dart    # OpenRouter API integration
│   ├── constants/
│   │   ├── api_constants.dart         # API configuration
│   │   └── app_constants.dart         # App-wide constants
│   ├── theme/
│   │   └── app_theme.dart             # Material 3 theme
│   └── utils/
│       └── storage_service.dart       # Local storage service
│
├── features/                  # Feature modules
│   └── analysis/
│       ├── models/
│       │   └── analysis_result.dart   # Data models
│       ├── providers/
│       │   └── analysis_provider.dart # Riverpod state management
│       ├── screens/
│       │   ├── home_screen.dart       # Main home screen
│       │   ├── input_screen.dart      # Code input screen
│       │   ├── result_screen.dart     # Analysis results
│       │   └── history_screen.dart    # Analysis history
│       └── widgets/
│           ├── code_diff_viewer.dart  # Diff comparison widget
│           └── code_viewer.dart       # Syntax highlighted code viewer
│
└── main.dart                  # App entry point
```

## 📦 Dependencies

### State Management
- `flutter_riverpod: ^2.5.1` - Modern state management

### Networking
- `http: ^1.2.2` - HTTP client for API calls

### UI Components
- `flutter_highlight: ^0.7.0` - Syntax highlighting
- `highlight: ^0.7.0` - Code highlighting support
- `flutter_code_editor: ^0.3.3` - Code editor widget

### Utilities
- `image_picker: ^1.1.2` - Image selection
- `diffutil_dart: ^3.0.0` - Diff algorithm
- `shared_preferences: ^2.3.3` - Local storage
- `path_provider: ^2.1.4` - Path utilities
- `intl: ^0.19.0` - Internationalization

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)
- OpenRouter API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ai_code_mentor
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your OpenRouter API key**
   
   Open `lib/core/constants/api_constants.dart` and replace:
   ```dart
   static const String apiKey = 'YOUR_API_KEY_HERE';
   ```
   
   With your actual API key:
   ```dart
   static const String apiKey = 'sk-or-v1-...';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔑 OpenRouter API Setup

1. Visit [OpenRouter.ai](https://openrouter.ai/)
2. Sign up for an account
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key and paste it in `lib/core/constants/api_constants.dart`

### Supported Models

The app is configured to use `openai/gpt-4-turbo-preview` by default. You can change this in `api_constants.dart`:

```dart
static const String defaultModel = 'anthropic/claude-3-opus';  // Example
```

## 📱 Usage

### 1. Home Screen
- Choose from three input methods:
  - **Paste Code**: Directly paste code for analysis
  - **Upload Screenshot**: Upload image of code
  - **Paste Error Logs**: Get help with error messages

### 2. Input Screen
- Enter your code in the text editor
- Optionally add error logs
- For screenshots, select an image from gallery
- Tap "Analyze with AI" to start analysis

### 3. Results Screen
Navigate through tabs:
- **Root Cause**: Understand what went wrong
- **Fixed Code**: See the corrected version
- **Diff View**: Compare original vs fixed code
- **Explanation**: Switch between Beginner/Intermediate/Expert levels
- **Best Practices**: Learn recommended approaches
- **Alternatives**: Explore other solutions

### 4. History Screen
- View all previous analyses
- Tap any item to see full details
- Organized by timestamp

## 🔧 Customization

### Changing API Model

Edit `lib/core/constants/api_constants.dart`:

```dart
static const String defaultModel = 'your-preferred-model';
```

### Theme Colors

Modify theme colors in `lib/core/theme/app_theme.dart`.

## 📊 Project Statistics

- **Total Files**: 14+ Dart files
- **Lines of Code**: 2000+
- **Features**: 4 main feature modules
- **Screens**: 4 primary screens
- **Widgets**: 6+ custom widgets

---

**Built with ❤️ using Flutter and OpenRouter AI**

