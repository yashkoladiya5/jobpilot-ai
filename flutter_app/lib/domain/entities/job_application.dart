import 'package:freezed_annotation/freezed_annotation.dart';
part 'job_application.freezed.dart';
part 'job_application.g.dart';

@freezed
class JobApplication with _$JobApplication {
  const factory JobApplication({
    required String id,
    @JsonKey(name: 'company_name') required String companyName,
    required String role,
    @JsonKey(name: 'job_url') String? jobUrl,
    @JsonKey(name: 'salary_range') String? salaryRange,
    String? location,
    required ApplicationStatus status,
    String? notes,
    @JsonKey(name: 'resume_id') String? resumeId,
    @JsonKey(name: 'applied_date') required DateTime appliedDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _JobApplication;

  factory JobApplication.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationFromJson(json);
}

@JsonEnum(valueField: 'value')
enum ApplicationStatus {
  @JsonValue('saved')
  saved('saved'),
  @JsonValue('applied')
  applied('applied'),
  @JsonValue('interview')
  interview('interview'),
  @JsonValue('offer')
  offer('offer'),
  @JsonValue('rejected')
  rejected('rejected'),
  @JsonValue('withdrawn')
  withdrawn('withdrawn');

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
