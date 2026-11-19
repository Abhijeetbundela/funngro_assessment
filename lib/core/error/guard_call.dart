import 'package:funngro_assessment/core/result/result.dart';

import 'exceptions.dart';
import 'failures.dart';

Future<Result<T>> guardCall<T>(Future<T> Function() body) async {
  try {
    return Success(await body());
  } on ApiException catch (e) {
    return Err(
      e.isNetwork ? NetworkFailure(e.message) : ServerFailure(e.message),
    );
  } catch (_) {
    return const Err(UnknownFailure());
  }
}
