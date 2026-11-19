import 'package:dio/dio.dart';
import 'package:funngro_assessment/core/network/dio_client.dart';
import 'package:funngro_assessment/features/earnings/data/models/earning_models.dart';

abstract interface class EarningsRemoteDataSource {
  Future<List<EarningModel>> fetchEarnings(String userId);

  Future<EarningDetailModel> fetchDetail(String earningId);
}

class DioEarningsRemoteDataSource implements EarningsRemoteDataSource {
  const DioEarningsRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<EarningModel>> fetchEarnings(String userId) async {
    try {
      final res = await _dio.get<List<dynamic>>('/users/$userId/earnings');
      return (res.data ?? const [])
          .map((e) => EarningModel.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<EarningDetailModel> fetchDetail(String earningId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/earnings/$earningId');
      return EarningDetailModel.fromJson(res.data!);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
