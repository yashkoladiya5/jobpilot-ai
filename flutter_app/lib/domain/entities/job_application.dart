import 'package:freezed_annotation/freezed_annotation.dart';
part 'job_application.freezed.dart';
part 'job_application.g.dart';

/// Represents a user's job application in the system.
/// Tracks company, role, current status, and optional notes.
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
    @Default(false) bool isFavorite,
    @Default(0) int interviewRounds,
  }) = _JobApplication;

  const JobApplication._(); // Added for custom getters in Freezed

  factory JobApplication.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationFromJson(json);

  bool get hasNotes => notes != null && notes!.trim().isNotEmpty;
  bool get hasSalaryInfo => salaryRange != null && salaryRange!.trim().isNotEmpty;
}

/// Standardized enum representing all possible stages of a job application.
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
