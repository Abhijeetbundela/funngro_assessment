import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/earnings/domain/entities/earning.dart';
import 'package:funngro_assessment/features/earnings/domain/repositories/earnings_repository.dart';

class GetEarnings {
  const GetEarnings(this._repository);

  final EarningsRepository _repository;

  Future<Result<List<Earning>>> call(String userId) =>
      _repository.getEarnings(userId);
}

class WatchWalletUpdates {
  const WatchWalletUpdates(this._repository);

  final EarningsRepository _repository;

  Stream<Earning> call(String userId) => _repository.watchWalletUpdates(userId);
}

class GetEarningDetail {
  const GetEarningDetail(this._repository);

  final EarningsRepository _repository;

  Future<Result<EarningDetail>> call(String earningId) =>
      _repository.getEarningDetail(earningId);
}
