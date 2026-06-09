import 'package:freezed_annotation/freezed_annotation.dart';
part 'resume.freezed.dart';
part 'resume.g.dart';

@freezed
class Resume with _$Resume {
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
}
