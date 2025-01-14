enum Flavour {
  development,
  staging,
  production;
}

enum PaginationStatus {
  initial,
  loaded,
  failure,
  loading,
}

enum PaginationType { cursor, page }

enum SecureStorageKey { bearerToken, refreshToken }
