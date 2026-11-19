import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/earnings/domain/entities/earning.dart';

abstract interface class EarningsRepository {
  Future<Result<List<Earning>>> getEarnings(String userId);

  Stream<Earning> watchWalletUpdates(String userId);

  Future<Result<EarningDetail>> getEarningDetail(String earningId);
}
