import 'package:injectable/injectable.dart';
import 'package:jobpilot_ai/core/constants/api_constants.dart';
import 'package:jobpilot_ai/core/network/dio_client.dart';

@lazySingleton
class DashboardRemoteDataSource {
  final DioClient _dioClient;
  DashboardRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> getStats() async {
    final response = await _dioClient.get(ApiConstants.dashboardStats);
    return response.data as Map<String, dynamic>;
  }
}
