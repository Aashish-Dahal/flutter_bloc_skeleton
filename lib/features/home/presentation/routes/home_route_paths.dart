/// Auth feature route segments and names. Keeps navigation constants inside the feature.
enum HomeRoute {
  home;

  String get path => switch (this) {
    HomeRoute.home => '/home',
  };

  String get routeName => switch (this) {
    HomeRoute.home => 'Home',
  };
}
