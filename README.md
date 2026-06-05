# eTrace - Expense Tracking Application

A comprehensive Flutter-based expense tracking application that helps users manage their finances with detailed expense tracking, income management, and reserve savings functionality.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [API Documentation](#api-documentation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Usage Guide](#usage-guide)
- [Future Works](#future-works)
- [Contributing](#contributing)

## 🎯 Overview

**eTrace** is a mobile application designed to give users complete control over their financial spending. It provides an intuitive interface for tracking expenses, managing income, and setting aside savings in reserves. The app uses a secure token-based authentication system and stores user data securely on the device.

### Version

- **Current Version**: 1.0.0+1
- **Flutter SDK**: ^3.10.7
- **Platform Support**: iOS, Android, Web, Windows, macOS, Linux

## ✨ Features

### Authentication & User Management

- **User Registration**: Create new accounts with username, email, password validation
- **User Login**: Secure login with username and password
- **Token Management**: Automatic token refresh mechanism with secure storage
- **Logout**: Secure session termination

### Expense Management

- **Add Expenses**: Record expenses with amount, date, category, and notes
- **View Expenses**: Browse all expenses with pagination support
- **Search Expenses**: Find expenses by various criteria with pagination
- **Update Expenses**: Modify existing expense details
- **Delete Expenses**: Remove expenses from records
- **Expense Categories**: Organize expenses by predefined categories
- **Reserved Expenses**: Mark expenses as reserved/savings

### Income Management

- **Add Income**: Record incoming funds to update user balance
- **Balance Tracking**: Real-time balance updates after income additions

### Reserve/Savings Management

- **Create Reserves**: Set up savings pots with custom labels
- **Deposit to Reserves**: Add funds to existing reserves
- **Withdraw from Reserves**: Withdraw funds with transaction tracking
- **Update Reserves**: Rename and update reserve details
- **Delete Reserves**: Remove reserve accounts
- **Reserve Transactions**: Track all reserve movements

### Additional Features

- **Category Management**: View and manage expense categories
- **App Updates**: Check for available app updates
- **Pagination Support**: Handle large datasets efficiently
- **Secure Storage**: Tokens stored securely using Flutter Secure Storage
- **Network Error Handling**: Robust error handling and recovery
- **State Management**: Efficient state caching with Flutter Riverpod

## 🛠️ Tech Stack

### Frontend Framework

- **Flutter**: UI framework for cross-platform mobile development
- **Material Design**: Material Design 3 components and patterns

### State Management

- **Flutter Riverpod**: State management and dependency injection
- **Provider Pattern**: Caching and notification-based state management

### Networking

- **Dio**: HTTP client with interceptors for API calls
- **Token-based Authentication**: Bearer token authorization

### Security & Storage

- **Flutter Secure Storage**: Secure token storage
- **TokenManager**: Custom token lifecycle management with auto-refresh

### Utilities

- **Flutter Dotenv**: Environment variable management
- **Intl**: Internationalization and date/time formatting
- **Package Info Plus**: App version and package information
- **URL Launcher**: External link handling
- **Flutter Slidable**: Swipeable list item actions
- **Pub Semver**: Semantic versioning for app updates

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point and routing
├── Api/                               # API services layer
│   ├── ApiClient.dart                 # Singleton HTTP client with interceptors
│   ├── AuthService.dart               # Authentication endpoints
│   ├── FetchService.dart              # Data fetching endpoints
│   ├── AddService.dart                # Data creation endpoints
│   ├── UpdateService.dart             # Data modification endpoints
│   ├── DeleteService.dart             # Data deletion endpoints
│   ├── TokenManager.dart              # Token lifecycle management
│   └── AppUpdateService.dart          # App version checking
├── Config/                            # Configuration
│   └── app_Config.dart                # App constants and settings
├── Model/                             # Data models
│   ├── User.dart                      # User model
│   ├── Expense.dart                   # Expense model
│   ├── Reserved.dart                  # Reserve/savings model
│   ├── Category.dart                  # Category model
│   ├── Balance.dart                   # Balance model
│   ├── Transaction.dart               # Transaction model
│   ├── ExpenseList.dart               # Expense list wrapper
│   ├── AppInfoResponse.dart           # App update info
│   └── UpdateStatus.dart              # Update status indicator
├── Notifiers/                         # State management
│   ├── auth/                          # Authentication state
│   ├── balance/                       # Balance state
│   ├── category/                      # Category state
│   └── transaction/                   # Transaction state
├── Pages/                             # UI pages/screens
│   ├── SplashPage.dart                # Splash/loading screen
│   ├── LoginPage.dart                 # User login
│   ├── RegisterPage.dart              # User registration
│   ├── HomePage.dart                  # Main dashboard
│   ├── HomeContent.dart               # Dashboard content
│   ├── ExpensePage.dart               # Expense list view
│   ├── ExpenseSearchPage.dart         # Expense search interface
│   ├── AddExpensePage.dart            # Add new expense
│   ├── UpdateExpensePage.dart         # Edit expense
│   ├── AddIncomePage.dart             # Add income
│   ├── ReservePage.dart               # Reserves list view
│   ├── AddReservePage.dart            # Create new reserve
│   ├── AddReserveMoneyPage.dart       # Deposit to reserve
│   ├── UpdateReservePage.dart         # Edit reserve
│   ├── WithdrawReserveMoney.dart      # Withdraw from reserve
│   └── ReportPage.dart                # Reports and analytics
└── Utils/                             # Utility functions and helpers
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: ^3.10.7
- Dart SDK: Included with Flutter
- Git
- An Android emulator or iOS simulator (or physical device)

### Installation Steps

1. **Clone the Repository**

   ```bash
   git clone <repository-url>
   cd etrace
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   - Create a `.env` file in the root directory
   - Add the following configuration:
     ```env
     BASE_URL=https://your-api-url.com
     ```

4. **Get Dart Code Generation (if needed)**
   ```bash
   flutter pub run build_runner build
   ```

## 🔌 API Documentation

### Base Configuration

- **Base URL**: Configured via `app_Config.dart`
- **Timeout**: 10 seconds for both connection and receive
- **Content-Type**: `application/json`
- **Authentication**: Bearer token in Authorization header

### Authentication Endpoints

#### Login

```
POST /api/auth/login
Content-Type: application/json

Request:
{
  "username": "string",
  "password": "string"
}

Response (200):
{
  "accessToken": "jwt_token",
  "refreshToken": "jwt_token"
}
```

#### Register

```
POST /api/auth/register
Content-Type: application/json

Request:
{
  "username": "string",
  "email": "string",
  "password": "string",
  "confirmPassword": "string",
  "name": "string"
}

Response (200):
{
  "userid": "int",
  "username": "string",
  "email": "string",
  "amount": "double"
}
```

### Income Endpoints

#### Add Income

```
POST /api/auth/income
Authorization: Bearer {accessToken}
Content-Type: application/json

Request:
{
  "amount": "double"
}

Response (200):
{
  "userid": "int",
  "username": "string",
  "email": "string",
  "amount": "double"
}
```

### Expense Endpoints

#### Fetch All Expenses (with Pagination)

```
GET /api/expense?page={page}&size={size}
Authorization: Bearer {accessToken}

Parameters:
- page: int (default: 0)
- size: int (default: 10)

Response (200):
[
  {
    "id": "int",
    "amount": "double",
    "expenseDate": "ISO8601",
    "category": "string",
    "note": "string",
    "isReserved": "boolean",
    "label": "string | null"
  }
]
```

#### Add Expense

```
POST /api/expense
Authorization: Bearer {accessToken}
Content-Type: application/json

Request:
{
  "amount": "double",
  "expenseDate": "ISO8601",
  "category": "string",
  "note": "string",
  "isReserved": "boolean",
  "label": "string | null"
}

Response (201):
{
  "id": "int",
  "amount": "double",
  "expenseDate": "ISO8601",
  "category": "string",
  "note": "string",
  "isReserved": "boolean",
  "label": "string | null"
}
```

#### Delete Expense

```
DELETE /api/expense/{id}
Authorization: Bearer {accessToken}

Response (200): Success
```

### Category Endpoints

#### Fetch All Categories

```
GET /api/category
Authorization: Bearer {accessToken}

Response (200):
[
  {
    "id": "int",
    "name": "string"
  }
]
```

#### Fetch Category by ID

```
GET /api/category/{id}
Authorization: Bearer {accessToken}

Response (200):
{
  "id": "int",
  "name": "string"
}
```

### Reserve/Savings Endpoints

#### Fetch All Reserves

```
GET /api/reserve
Authorization: Bearer {accessToken}

Response (200):
[
  {
    "id": "int",
    "label": "string",
    "amount": "double",
    "note": "string"
  }
]
```

#### Add Reserve

```
POST /api/reserve
Authorization: Bearer {accessToken}
Content-Type: application/json

Request:
{
  "label": "string",
  "note": "string"
}

Response (201):
{
  "id": "int",
  "label": "string",
  "amount": "double",
  "note": "string"
}
```

#### Deposit to Reserve

```
POST /api/reserve/deposit
Authorization: Bearer {accessToken}
Content-Type: application/json

Request:
{
  "amount": "double",
  "label": "string"
}

Response (200):
{
  "id": "int",
  "label": "string",
  "amount": "double",
  "note": "string"
}
```

#### Withdraw from Reserve

```
POST /api/reserve/withdraw
Authorization: Bearer {accessToken}
Content-Type: application/json

Request:
{
  "amount": "double",
  "label": "string"
}

Response (200):
{
  "id": "int",
  "label": "string",
  "amount": "double",
  "note": "string"
}
```

#### Update Reserve

```
PUT /api/reserve
Authorization: Bearer {accessToken}
Content-Type: application/json

Request:
{
  "old_label": "string",
  "new_label": "string",
  "note": "string"
}

Response (200):
{
  "id": "int",
  "label": "string",
  "amount": "double",
  "note": "string"
}
```

#### Delete Reserve

```
DELETE /api/reserve/{id}
Authorization: Bearer {accessToken}

Response (200): Success
```

### Balance Endpoints

#### Fetch User Balance

```
GET /api/auth/balance
Authorization: Bearer {accessToken}

Response (200):
{
  "userid": "int",
  "username": "string",
  "email": "string",
  "amount": "double"
}
```

### App Update Endpoints

#### Check for App Updates

```
GET /api/app/update
Authorization: Bearer {accessToken}

Response (200):
{
  "latestVersion": "string",
  "updateUrl": "string",
  "forceUpdate": "boolean",
  "releaseNotes": "string"
}
```

### Error Handling

All endpoints return standard HTTP status codes:

- **200 OK**: Successful request
- **201 Created**: Resource created successfully
- **400 Bad Request**: Invalid request parameters
- **401 Unauthorized**: Missing or invalid authentication token
- **403 Forbidden**: Access denied
- **404 Not Found**: Resource not found
- **500 Internal Server Error**: Server error

## ⚙️ Configuration

### App Config (`lib/Config/app_Config.dart`)

```dart
class AppConfig {
  static const String baseUrl = 'https://your-api-url.com';
  // Add other configuration constants here
}
```

### Environment Variables (`.env`)

```env
BASE_URL=https://api.example.com
```

## 🏃 Running the Application

### Development Build

**Android**

```bash
flutter run -d android
```

**iOS**

```bash
flutter run -d ios
```

**Web**

```bash
flutter run -d chrome
```

**Windows**

```bash
flutter run -d windows
```

**macOS**

```bash
flutter run -d macos
```

**Linux**

```bash
flutter run -d linux
```

### Release Build

**Android APK**

```bash
flutter build apk --release
```

**Android App Bundle**

```bash
flutter build appbundle --release
```

**iOS**

```bash
flutter build ios --release
```

**Web**

```bash
flutter build web --release
```

## 📱 Usage Guide

### User Registration

1. Launch the app
2. Navigate to the registration page
3. Enter username, email, name, password, and confirm password
4. Tap "Register" to create account
5. Upon success, user data is returned

### User Login

1. On the login page, enter username and password
2. Tap "Login"
3. Tokens are automatically stored securely
4. Redirected to home page upon success

### Adding an Expense

1. Navigate to "Add Expense" page
2. Fill in the following details:
   - **Amount**: Expense amount
   - **Date**: Expense date (defaults to today)
   - **Category**: Select from available categories
   - **Note**: Optional note/description
   - **Reserved**: Toggle if this is a reserved/savings expense
   - **Label**: If reserved, select the reserve account
3. Tap "Add Expense" to save

### Searching Expenses

1. Go to "Search Expenses" page
2. Enter search criteria
3. Results display with pagination support
4. Scroll to load more expenses

### Managing Income

1. Navigate to "Add Income" page
2. Enter the income amount
3. Tap "Add Income"
4. User balance updates automatically

### Managing Reserves

1. **Create Reserve**: Go to "Add Reserve", enter label and note
2. **Deposit**: "Add Reserve Money", select reserve, enter amount
3. **Withdraw**: "Withdraw", select reserve, enter amount
4. **Update**: "Update Reserve", change label or note
5. **Delete**: Swipe on reserve and confirm deletion

### Viewing Reports

1. Navigate to "Reports" page
2. View expense analytics and summaries
3. Export reports (future feature)

## 🔮 Future Works

### Phase 2 - Analytics & Reporting

- **Expense Reports**: Generate detailed expense reports by category, date range
- **Charts & Visualizations**:
  - Pie charts for expense distribution
  - Line graphs for spending trends
  - Bar charts for monthly comparisons
- **Export Functionality**:
  - PDF report generation
  - CSV export for spreadsheet analysis
  - Email report delivery
- **Budget Management**:
  - Set category budgets
  - Budget alerts and notifications
  - Budget vs. actual comparisons

### Phase 3 - Advanced Features

- **Multi-currency Support**: Handle transactions in different currencies
- **Recurring Expenses**: Set up automatic recurring transactions
- **Receipt Capture**: OCR-based receipt scanning and storage
- **Data Synchronization**: Cloud backup and sync across devices
- **Advanced Search**: Filter by date range, amount range, multiple categories
- **Transaction Tags**: Custom tagging for better organization

### Phase 4 - Social & Collaborative

- **Shared Expenses**: Split expenses among multiple users
- **Group Budgets**: Collaborative budget management
- **Social Sharing**: Share reports with others
- **Notifications**: Push notifications for budget alerts

### Phase 5 - Integration & Automation

- **Bank Integration**: Connect with banking APIs for auto-import
- **Payment Integrations**: Direct payment processing
- **Calendar Integration**: Link expenses to calendar events
- **API Webhooks**: Trigger actions on specific events

### Phase 6 - AI & Machine Learning

- **Spending Insights**: AI-powered spending analysis and recommendations
- **Duplicate Detection**: Automatically identify and merge duplicate transactions
- **Category Auto-suggestion**: ML-based automatic category assignment
- **Anomaly Detection**: Detect unusual spending patterns

### Phase 7 - Mobile Enhancements

- **Offline Mode**: Work offline with sync when online
- **Biometric Authentication**: Face/Fingerprint login
- **Widgets**: Home screen widgets for quick balance view
- **Siri/Google Assistant Integration**: Voice commands for adding expenses

## 📝 Development Notes

### Known Issues

- None currently documented

## 🤝 Contributing

To contribute to eTrace:

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit your changes (`git commit -m 'Add amazing feature'`)
3. Push to the branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

## 📄 License

This project is private and not licensed for public distribution.

## 👤 Contact

For questions or support, please contact the development team.

---

**Last Updated**: June 2026
**Version**: 1.0.0+1
