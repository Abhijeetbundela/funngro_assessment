import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/earnings/domain/entities/earning.dart';
import 'package:funngro_assessment/features/earnings/domain/usecases/earnings_usecases.dart';

enum DetailStatus { loading, loaded, failed }

final class EarningDetailState extends Equatable {
  const EarningDetailState({
    this.status = DetailStatus.loading,
    this.detail,
    this.message,
  });

  final DetailStatus status;
  final EarningDetail? detail;
  final String? message;

  @override
  List<Object?> get props => [status, detail, message];
}

class EarningDetailCubit extends Cubit<EarningDetailState> {
  EarningDetailCubit(this._getEarningDetail)
    : super(const EarningDetailState());

  final GetEarningDetail _getEarningDetail;

  Future<void> load(String earningId) async {
    emit(const EarningDetailState());
    final result = await _getEarningDetail(earningId);
    if (isClosed) return;
    switch (result) {
      case Success(:final value):
        emit(EarningDetailState(status: DetailStatus.loaded, detail: value));
      case Err(:final failure):
        emit(
          EarningDetailState(
            status: DetailStatus.failed,
            message: failure.message,
          ),
        );
    }
  }
}
