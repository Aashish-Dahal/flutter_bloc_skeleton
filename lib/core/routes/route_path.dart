import '../../features/auth/presentation/routes/auth_route_paths.dart';
import '../../features/cart/presentation/routes/cart_route_paths.dart';

enum AppPage { home, login, register, cart }

extension AppPageExtension on AppPage {
  String get toPath {
    switch (this) {
      case AppPage.login:
        return AuthRoute.login.path;
      case AppPage.register:
        return AuthRoute.register.path;
      case AppPage.home:
        return '/';
      case AppPage.cart:
        return CartRoute.cart.path;
    }
  }

  String get toName {
    switch (this) {
      case AppPage.login:
        return AuthRoute.login.routeName;
      case AppPage.register:
        return AuthRoute.register.routeName;
      case AppPage.home:
        return 'Home';
      case AppPage.cart:
        return CartRoute.cart.routeName;
    }
  }
}
