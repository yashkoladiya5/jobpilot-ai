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

  /// Formats the file size into a readable string (KB/MB).
  String get formattedSize {
    if (fileSize == null || fileSize! <= 0) return 'Unknown Size';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
