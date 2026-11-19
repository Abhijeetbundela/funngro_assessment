import 'dart:math';

import 'package:funngro_assessment/core/error/exceptions.dart';
import 'package:funngro_assessment/features/earnings/data/models/earning_models.dart';

import 'earnings_remote_data_source.dart';
import 'wallet_updates_data_source.dart';

class FakeEarningsRemoteDataSource implements EarningsRemoteDataSource {
  final _rng = Random();

  @override
  Future<List<EarningModel>> fetchEarnings(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (_rng.nextInt(6) == 0) throw ApiException('server error');
    final now = DateTime.now();
    return List.generate(
      3000,
      (i) => EarningModel(
        id: 'e${3000 - i}',
        title: 'Payout #${3000 - i}',
        amount: (50 + _rng.nextInt(950)).toDouble(),
        createdAt: now.subtract(Duration(hours: i)),
      ),
      growable: false,
    );
  }

  @override
  Future<EarningDetailModel> fetchDetail(String earningId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (_rng.nextInt(6) == 0) throw ApiException('server error');
    return EarningDetailModel(
      id: earningId,
      description: 'Details for $earningId',
      status: 'Paid',
    );
  }
}

class FakeWalletUpdatesDataSource implements WalletUpdatesDataSource {
  @override
  Stream<EarningModel> updates(String userId) {
    return Stream<EarningModel>.periodic(const Duration(seconds: 8), (i) {
      return EarningModel(
        id: 'live-$i',
        title: 'Live payout #$i',
        amount: 100 + (i * 10 % 400).toDouble(),
        createdAt: DateTime.now(),
      );
    });
  }
}
