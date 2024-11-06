class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T result;

  ApiResponse({required this.statusCode, required this.message, required this.result});

  // Método factory para mapear JSON a la clase ApiResponse
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) create) {
    return ApiResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      result: create(json['result']),
    );
  }
}
