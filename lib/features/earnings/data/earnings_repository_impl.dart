import 'package:funngro_assessment/core/error/guard_call.dart';
import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/earnings/domain/entities/earning.dart';
import 'package:funngro_assessment/features/earnings/domain/repositories/earnings_repository.dart';

import 'datasource/earnings_remote_data_source.dart';
import 'datasource/wallet_updates_data_source.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  const EarningsRepositoryImpl(this._remote, this._wallet);

  final EarningsRemoteDataSource _remote;
  final WalletUpdatesDataSource _wallet;

  @override
  Future<Result<List<Earning>>> getEarnings(String userId) =>
      guardCall(() => _remote.fetchEarnings(userId));

  @override
  Future<Result<EarningDetail>> getEarningDetail(String earningId) =>
      guardCall(() => _remote.fetchDetail(earningId));

  @override
  Stream<Earning> watchWalletUpdates(String userId) => _wallet.updates(userId);
}
