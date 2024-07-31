class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  ApiResponse({required this.success, this.data, this.message});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponse(
      success: json['success'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T?) toJsonT) {
    return {
      'success': success,
      'data': data != null ? toJsonT(data) : null,
      'message': message,
    };
  }
}
