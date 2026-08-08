import 'package:freezed_annotation/freezed_annotation.dart';
part 'resume.freezed.dart';
part 'resume.g.dart';

/// Represents an uploaded resume file associated with a user.
/// Contains metadata about the file such as size, type, and primary status.
@freezed
class Resume with _$Resume {
  const Resume._(); // Added for custom getters

  /// Factory constructor for generating a Resume instance.
  const factory Resume({
    required String id,
    required String userId,
    required String fileName,
    required String filePath,
    int? fileSize,
    String? mimeType,
    bool? isPrimary,
    DateTime? createdAt,
  }) = _Resume;

  factory Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);

  /// Returns the extension of the file name, in lowercase.
  String get fileExtension => fileName.split('.').last.toLowerCase();
}
