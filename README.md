# Flutter Bloc Skeleton

A structured Flutter project template utilizing the BLoC (Business Logic Component) pattern. This skeleton provides a scalable foundation for Flutter applications, promoting clean architecture and maintainability.

## 📦 Used Packages

State Management

- [Flutter bloc](https://pub.dev/packages/flutter_bloc)

Navigation

- [Go router](https://pub.dev/packages/go_router)

Localization / i18n

- [Easy Localization](https://pub.dev/packages/easy_localization)

Form Validation

- [Flutter Form Builder](https://pub.dev/packages/flutter_form_builder)
- [Form Builder Validators](https://pub.dev/packages/form_builder_validators)

HTTP Requests

- [Dio](https://pub.dev/packages/dio)

Dependency Injection

- [Get it](https://pub.dev/packages/get_it)

Local Storage

- [Shared Preferences](https://pub.dev/packages/shared_preferences)

Secure Token Storage

- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

Responsive Design

- [Flutter Screenutil](https://pub.dev/packages/flutter_screenutil)
- [Sizer](https://pub.dev/packages/sizer)

---

### 🔄 State Management Approach

- BLoC Pattern (flutter_bloc)

- Clean separation of layers using Clean Architecture

- Organized with Feature-First Folder Structure

### 🚀 Navigation

- Powered by GoRouter

- Deep linking and nested navigation ready

- Route guards and redirection logic supported

### 🌍 Localization / Internationalization

- Implemented with Easy Localization

- Supports dynamic locale switching

- Translations managed in `assets/translations/`

### ✅ Form Validation

- Built with Flutter Form Builder

- Extensible and complex form support

- Validators via Form Builder Validators

Validators

### 🌐 HTTP Handling

- Uses Dio for robust and interceptable HTTP requests

- Base client setup for consistent API usage

- Dummy JSON endpoints integrated for testing

### 🧩 Dependency Injection

- Based on GetIt

- Annotation-based DI with generated boilerplate

- Clean and testable service initialization

### 💾 Local & Secure Storage

- Shared Preferences for non-sensitive local data

- Flutter Secure Storage for secure token (e.g., Bearer, Refresh Token) handling

### handling

🧱 Design Pattern & Principles

- ✅ Atomic Design Pattern for building UI components

- ✅ SOLID Principles enforced for maintainable and scalable architecture

### 📱 Responsive Design

- Built-in support for Responsive UI

- Adapts layouts across mobile, tablet, and desktop

- Common packages: flutter_screenutil, layout_builder, etc.

### 🎯 Added Features

#### 🔄 Pagination

- Cursor-based and limit/offset pagination examples

- Reusable pagination logic

#### 🔐 Authentication

- API Authentication → in `main` branch

- Firebase Authentication → in `firebase` branch

- Supabase Authentication → in `supabase` branch

#### 🎨 Theme Management

- Dark and Light mode toggle

- Theme is fully customizable via ThemeData

#### 🧹 Code Optimization & Tooling

- ✅ Strict Lint Rules via analysis_options.yaml

- ✅ Pre-Commit Hooks for formatting and analysis — implemented inside the `hooks/` folder

- ✅ Model Generator:

- - Custom Dart model generator utility

- - Reduces manual work for model creation (from JSON)

## 📁 Folder Structure

```
flutter_bloc_skeleton/
├── .assets/
├── .generator/
├── .hooks/
├── lib/
│   ├── app/
│   ├── config/
│   ├── core/
│   │   └── common/
│   │       └── pagination_bloc/
│   ├── utils/
│   │   ├── assets/
│   │   ├── constants/
│   │   ├── enums/
│   │   ├── extension/
│   │   ├── path_provider/
│   │   ├── strings/
│   │   ├── typedefs/
│   │   └── validators/
│   ├── models/
│   ├── pages/
│   │   └── feature_name/
│   │       ├── bloc/
│   │       └── page.dart
│   ├── repository/
│   ├── services/
│   ├── widgets/
│   │   ├── atoms/
│   │   ├── molecules/
│   │   └── organisms/
│   ├── app.dart
│   ├── main.dart
│   ├── config.dart
│   └── injector.dart
├── pubspec.yaml
├── makefile
├── analysis_options.yaml
└── README.md
```

---

### `.assets/`

- Stores raw assets like images, icons, translations, fonts, etc.

- Typically referenced through asset management utilities.

### `.generator/`

- Home of the Dart model generator utility.

- Automates creation of model classes from JSON, reducing boilerplate and ensuring consistency.

### `.hooks/`

- Contains Pre-Commit Hook Scripts.

- Used to format code, run analysis, or tests before each Git commit to maintain code quality.

### `lib/app/`

- Entry point of the folder structure.

### `lib/app/config/`

- Centralized configuration layer:

- API Config (e.g., base URLs)

- Theme Config

- GoRouter Setup

- Route Definitions

### `lib/app/core/`

- Common layer containing reusable utilities and foundational logic:

- common `/pagination_bloc/`
  Contains shared pagination logic:

- - Limit-based pagination

- - Cursor-based pagination

- - Can be reused across different features.

### `lib/app/utils/`

- Holds global utilities and helpers:

- `assets/`: Central asset manager (e.g., image paths, icons)

- `constants/`: Global constants (e.g., spacing, padding, keys)

- `enums/`: App-wide enumerations

- `extension/`: Dart extension methods

- `path_provider/`: Helpers for accessing file paths

- `strings/`: Centralized string literals or keys

- `typedefs/`: Useful type aliases for better readability

- `validators/`: Contains Field validators for forms (email, password, etc.)

### `lib/app/models/`

- Contains Dart model classes representing API responses or local data structures.

### `lib/pages/`

- Feature-specific pages and their respective BLoC files:

- Follows feature-first organization

- Each feature (e.g., auth, profile) includes:

- - Its screen/page

- - Its bloc/cubit for managing state

### `lib/app/repository/`

- Handles business logic and data abstraction.

- Communicates with services and data sources (e.g., APIs, local storage).

### `lib/app/services/`

- Low-level services for data fetching, local caching, secure storage, etc.

- E.g., API service using Dio, storage service, auth service.

### `lib/app/widgets/`

- Reusable UI components following Atomic Design Pattern:

- - `Atoms`: Basic UI elements (buttons, text, icons)

- - `Molecules`: Combinations of atoms (e.g., text input with label)

- - `Organisms`: Larger UI blocks made of molecules (e.g., login form)

### `app.dart/main.dart`

- Root of the application.

- Sets up theme, router, localization, and initializes the app.

### `injector.dart`

- Configures dependency injection using get_it and injectable.

- Registers all services, blocs, and repositories.

### `config.dart`

- Centralized file for app-wide configurations like:

- - Base URL

- - App locale

- - Environment (dev/staging/prod)

### Prerequisites

Make sure you have Flutter installed on your machine. If you haven't installed Flutter yet, you can follow the official Flutter installation guide: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

### Installation

1. Clone the repository to your local machine using the following command:

```
git clone https://github.com/Aashish-Dahal/flutter_bloc_skeleton
```

2. Change into the project directory using the following command:

```
cd flutter_bloc_skeleton
```

3. Run this command to set up the project:

```
 make project-setup
 make flutter-clean
```

4. Run the project using the following command:

```
  flutter run
```

This will launch the app on your connected device or emulator.

### Environments

Place the env files like `config.dart, google-services.json, GoogleService.plist` inside respective `env/<dev|prod>`
folder.

And you can run `make set-env-dev | make set-env-prod` in terminal to set the required environment files.

### Material Theme Setup

Use this Material Design 3 Theme Generator website to design themes for both dark and light modes.

- [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/)

## Coding Guidelines

Additionally, utilize this article to enhance the quality of your code. This resource encompasses guidelines for naming conventions, code style and formatting, as well as other best practices.

- [medium-article](https://medium.com/readytowork-org/flutter-best-practices-and-coding-guidelines-f494b1ad2369)

## Usage

You can start building your Flutter application on top of this skeleton project. Modify or replace the existing code to fit your application's requirements. The skeleton project provides an example structure and initial code to get you started quickly.

## Testing

The `test/` directory contains files and examples to help you write tests for your Flutter application. It is recommended to follow good testing practices and write unit, integration, and widget tests to ensure the stability and correctness of your code.

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue on the GitHub repository. If you'd like to contribute code, you can fork the repository, create a new branch, make your changes, and submit a pull request.

Please make sure to follow the existing coding style and conventions in the project.

## License

This project is licensed under the [MIT License](LICENSE).
