class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T result;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.result,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic>? json, T Function(dynamic) create) {
    // Check if json is null or lacks required keys
    if (json == null) {
      throw Exception('Failed to parse API response: Response is null.');
    }

    // Extract status code and message, with fallback values if missing
    final statusCode = json['statusCode'] ?? 0;
    final message = json['message'] ?? 'Unknown error';

    try {
      final resultData = json['result'];

      // Handle the result as a List or a single item, if present
      if (resultData is List) {
        return ApiResponse(
          statusCode: statusCode,
          message: message,
          result: resultData.map((item) => create(item)).toList() as T,
        );
      } else if (resultData != null) {
        return ApiResponse(
          statusCode: statusCode,
          message: message,
          result: create(resultData),
        );
      } else {
        // Handle cases where result is null
        throw Exception('Failed to parse API response: Result is null.');
      }
    } catch (e) {
      // Optional: log the error for debugging purposes
      print('Error parsing ApiResponse: $e');
      throw Exception('Failed to parse API response');
    }
  }
}
