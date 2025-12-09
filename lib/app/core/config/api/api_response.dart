class ApiResponse<T> {
  final T data;
  final int statusCode;
  final int count;

  ApiResponse({required this.data, required this.statusCode, this.count = 0});

  ApiResponse<T> copyWith({T? data, int? statusCode, int? count}) {
    return ApiResponse<T>(
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
      count: count ?? this.count,
    );
  }
}
