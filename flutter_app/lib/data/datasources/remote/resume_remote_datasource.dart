import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/constants/api_constants.dart';
import 'package:jobpilot_ai/core/network/dio_client.dart';

/// Maps a resume file-path extension to the MIME type expected by the backend
/// whitelist (`application/pdf`, `application/msword`,
/// `application/vnd.openxmlformats-officedocument.wordprocessingml.document`,
/// `text/plain`). Returns null for unsupported extensions so dio falls back to
/// `application/octet-stream`, which the backend correctly rejects.
DioMediaType? _contentTypeFor(String filePath) {
  final extension = filePath.toLowerCase().split('.').last;
  switch (extension) {
    case 'pdf':
      return DioMediaType('application', 'pdf');
    case 'doc':
      return DioMediaType('application', 'msword');
    case 'docx':
      return DioMediaType(
        'application',
        'vnd.openxmlformats-officedocument.wordprocessingml.document',
      );
    case 'txt':
      return DioMediaType('text', 'plain');
    default:
      return null;
  }
}

@lazySingleton
class ResumeRemoteDataSource {
  final DioClient _dioClient;
  ResumeRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> uploadResume(String filePath) async {
    final formData = FormData.fromMap({
      'resume': await MultipartFile.fromFile(
        filePath,
        contentType: _contentTypeFor(filePath),
      ),
    });
    final response = await _dioClient.upload(
      ApiConstants.uploadResume,
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getResumes() async {
    final response = await _dioClient.get(ApiConstants.resumes);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> setPrimaryResume(String id) async {
    final response = await _dioClient.patch(ApiConstants.resumeSetPrimary(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteResume(String id) async {
    final response = await _dioClient.delete(ApiConstants.resumeDetail(id));
    return response.data as Map<String, dynamic>;
  }
}
