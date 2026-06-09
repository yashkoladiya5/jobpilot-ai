import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/constants/api_constants.dart';
import 'package:jobpilot_ai/core/network/dio_client.dart';

@lazySingleton
class JobRemoteDataSource {
  final DioClient _dioClient;
  JobRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> getJobs() async {
    final response = await _dioClient.get(ApiConstants.jobs);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getJobById(String id) async {
    final response = await _dioClient.get(ApiConstants.jobDetail(id));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createJob(Map<String, dynamic> data) async {
    final response = await _dioClient.post(ApiConstants.jobs, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateJob(
      String id, Map<String, dynamic> data) async {
    final response = await _dioClient.put(ApiConstants.jobDetail(id), data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteJob(String id) async {
    final response = await _dioClient.delete(ApiConstants.jobDetail(id));
    return response.data as Map<String, dynamic>;
  }
}
