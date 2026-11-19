import 'package:funngro_assessment/features/earnings/data/models/earning_models.dart';

abstract interface class WalletUpdatesDataSource {
  Stream<EarningModel> updates(String userId);
}

// TODO replace stream with a WebSocket or SSE client