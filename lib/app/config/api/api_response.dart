class ApiResponse<T> {
  final T data;
  final int statusCode;
  final int count;

  ApiResponse({required this.data, required this.statusCode, this.count = 0});
}
