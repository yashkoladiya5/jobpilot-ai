import 'package:freezed_annotation/freezed_annotation.dart';
part 'resume.freezed.dart';
part 'resume.g.dart';

@freezed
class Resume with _$Resume {
  const factory Resume({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'file_path') required String filePath,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'is_primary') bool? isPrimary,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Resume;

  factory Resume.fromJson(Map<String, dynamic> json) => _$ResumeFromJson(json);
}
