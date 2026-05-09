abstract interface class BaseState<T> {}

abstract interface class BaseInitial<T> implements BaseState<T> {}

abstract interface class BaseLoading<T> implements BaseState<T> {}

abstract interface class BaseLoaded<T> implements BaseState<T> {
  T get res;
}

abstract interface class BaseFailure<T> implements BaseState<T> {
  String get message;
}

abstract interface class BaseEmpty<T> implements BaseState<T> {}
