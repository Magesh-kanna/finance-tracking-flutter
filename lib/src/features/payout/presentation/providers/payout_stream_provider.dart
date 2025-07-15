import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paywize/src/common/database/database_helper.dart';
import 'package:paywize/src/features/payout/data/models/payout_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payout_stream_provider.g.dart';

@Riverpod(keepAlive: true)
/// [payoutStream] returns the payouts from local sqldatabase
Stream<List<PayoutModel>> payoutStream(Ref ref) {
  try {
    return PaywizeDB.watchAllPayouts();
  } catch (e, s) {
    print(e);
    print(s);
    return Stream.value(<PayoutModel>[]);
  }
}
