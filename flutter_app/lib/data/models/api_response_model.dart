class ApiResponseModel<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? meta;

  const ApiResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.meta,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}
