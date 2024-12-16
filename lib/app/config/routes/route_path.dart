enum AppPage { home, login, register, error, detail }

extension AppPageExtension on AppPage {
  String get toPath {
    switch (this) {
      case AppPage.login:
        return '/login';
      case AppPage.register:
        return '/register';
      case AppPage.detail:
        return '/detail';
      case AppPage.error:
        return '/error';
      case AppPage.home:
        return '/';
      default:
        return '/onboarding';
    }
  }

  String get toName {
    switch (this) {
      case AppPage.login:
        return "Login";
      case AppPage.register:
        return "Register";
      case AppPage.detail:
        return "Detail";
      case AppPage.home:
        return "Home";
      case AppPage.error:
        return "Error";
      default:
        return "Onboarding";
    }
  }
}
