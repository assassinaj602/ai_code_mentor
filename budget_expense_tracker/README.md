# Budget & Expense Tracker

## Overview
The Budget & Expense Tracker is a Flutter mobile application designed to help users manage their finances by tracking their expenses and budgets. The app provides a user-friendly interface for adding, editing, and viewing expenses, as well as generating reports to analyze spending habits.

## Features
- **User Authentication**: Secure login and registration for users.
- **Expense Management**: Add, edit, and delete expenses with detailed information.
- **Category Management**: Select from predefined categories or create custom categories for expenses.
- **Reports**: View monthly reports with total expenses and category-wise breakdowns using graphs.
- **Budget Overview**: Display a summary of the monthly budget and today's expenses.
- **Responsive Design**: Optimized for both Android and iOS devices.

## Project Structure
```
budget_expense_tracker
├── lib
│   ├── main.dart                  # Entry point of the application
│   ├── models
│   │   ├── expense.dart           # Expense model class
│   │   └── category.dart          # Category model class
│   ├── screens
│   │   ├── home_screen.dart       # Home screen displaying budget summary and expenses
│   │   ├── add_expense_screen.dart # Screen for adding/editing expenses
│   │   └── report_screen.dart      # Screen for viewing reports
│   ├── widgets
│   │   ├── expense_list.dart       # Widget for displaying a list of expenses
│   │   ├── category_selector.dart   # Widget for selecting categories
│   │   └── chart.dart              # Widget for displaying charts
│   ├── utils
│   │   └── constants.dart          # Constants used throughout the app
│   └── services
│       └── database_service.dart   # Database operations for expenses and categories
├── pubspec.yaml                    # Project configuration and dependencies
├── android                         # Android-specific files
├── ios                             # iOS-specific files
├── test
│   └── widget_test.dart            # Widget tests for the application
└── README.md                       # Project documentation
```

## Installation
1. Clone the repository:
   ```
   git clone https://github.com/yourusername/budget_expense_tracker.git
   ```
2. Navigate to the project directory:
   ```
   cd budget_expense_tracker
   ```
3. Install the dependencies:
   ```
   flutter pub get
   ```
4. Run the application:
   ```
   flutter run
   ```

## Usage
- Launch the app and create an account or log in.
- Use the home screen to view your budget summary and add expenses.
- Navigate to the reports screen to analyze your spending habits.
- Customize your categories as needed.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.