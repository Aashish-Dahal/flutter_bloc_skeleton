# Flutter Bloc Skeleton

This is a skeleton project for Flutter that provides a basic structure and configuration to kickstart your Flutter application development.

This project is a starting point for a Flutter application that follows the
[Bloc State management tutorial](https://bloclibrary.dev/).

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a
full API reference.

## Features

- Boilerplate code and folder structure for a Flutter project.
- Pre-configured dependencies and packages commonly used in Flutter development.
- Example code and comments to help you get started quickly.

## Getting Started

These instructions will help you get a copy of the project up and running on your local machine for development and testing purposes.

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
