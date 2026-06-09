import 'package:freezed_annotation/freezed_annotation.dart';
part 'job_application.freezed.dart';
part 'job_application.g.dart';

@freezed
class JobApplication with _$JobApplication {
  const factory JobApplication({
    required String id,
    required String companyName,
    required String role,
    String? jobUrl,
    String? salaryRange,
    String? location,
    required ApplicationStatus status,
    String? notes,
    String? resumeId,
    required DateTime appliedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JobApplication;

  factory JobApplication.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationFromJson(json);
}

@JsonEnum(valueField: 'value')
enum ApplicationStatus {
  @JsonValue('SAVED')
  saved('SAVED'),
  @JsonValue('APPLIED')
  applied('APPLIED'),
  @JsonValue('INTERVIEW')
  interview('INTERVIEW'),
  @JsonValue('OFFER')
  offer('OFFER'),
  @JsonValue('REJECTED')
  rejected('REJECTED'),
  @JsonValue('WITHDRAWN')
  withdrawn('WITHDRAWN');

  final String value;
  const ApplicationStatus(this.value);

  String toJson() => value;

  static ApplicationStatus fromJson(String json) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.value == json,
      orElse: () => ApplicationStatus.saved,
    );
  }
}
