import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/network/dio_client.dart';
import 'package:jobpilot_ai/core/constants/api_constants.dart';

@lazySingleton
class ResumeRemoteDataSource {
  final DioClient _dioClient;
  ResumeRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> uploadResume(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
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

  Future<Map<String, dynamic>> deleteResume(String id) async {
    final response = await _dioClient.delete(ApiConstants.resumeDetail(id));
    return response.data as Map<String, dynamic>;
  }
}
