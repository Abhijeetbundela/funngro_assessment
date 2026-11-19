import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funngro_assessment/core/formatting/currency_formatter.dart';
import 'package:funngro_assessment/core/result/result.dart';
import 'package:funngro_assessment/features/earnings/domain/entities/earning.dart';
import 'package:funngro_assessment/features/earnings/domain/usecases/earnings_usecases.dart';

part 'earnings_event.dart';

part 'earnings_state.dart';

class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  EarningsBloc({
    required this.userId,
    required this._getEarnings,
    required this._watchWalletUpdates,
    required this._formatter,
  }) : super(const EarningsState()) {
    on<EarningsStarted>(_onStarted, transformer: droppable());
    on<EarningsRefreshed>(_onRefreshed, transformer: droppable());
    on<EarningsUpdateReceived>(_onUpdate);
  }

  final String userId;
  final GetEarnings _getEarnings;
  final WatchWalletUpdates _watchWalletUpdates;
  final CurrencyFormatter _formatter;

  StreamSubscription<Earning>? _sub;
  final Set<String> _ids = {};
  final List<Earning> _buffer = [];
  bool _fetching = false;

  EarningItem _toItem(Earning e) =>
      EarningItem(earning: e, amountLabel: _formatter.format(e.amount));

  List<EarningItem> _buildItems(List<Earning> snapshot) {
    _ids
      ..clear()
      ..addAll(snapshot.map((e) => e.id));
    var items = <EarningItem>[for (final e in snapshot) _toItem(e)];
    for (final u in _buffer) {
      if (_ids.add(u.id)) items = [_toItem(u), ...items];
    }
    _buffer.clear();
    return items;
  }

  Future<void> _onStarted(
    EarningsStarted event,
    Emitter<EarningsState> emit,
  ) async {
    emit(const EarningsState());

    _sub ??= _watchWalletUpdates(userId).listen((e) {
      if (!isClosed) add(EarningsUpdateReceived(e));
    }, onError: (Object _) {});

    _fetching = true;
    try {
      final result = await _getEarnings(userId);
      if (emit.isDone) return;
      switch (result) {
        case Success(:final value):
          emit(
            EarningsState(
              status: EarningsStatus.ready,
              items: _buildItems(value),
            ),
          );
        case Err(:final failure):
          emit(
            EarningsState(
              status: EarningsStatus.failure,
              message: failure.message,
            ),
          );
      }
    } finally {
      _fetching = false;
    }
  }

  Future<void> _onRefreshed(
    EarningsRefreshed event,
    Emitter<EarningsState> emit,
  ) async {
    try {
      if (state.status != EarningsStatus.ready) return;
      _fetching = true;
      emit(state.copyWith(refreshFailed: false));
      final result = await _getEarnings(userId);
      if (emit.isDone) return;
      switch (result) {
        case Success(:final value):
          emit(
            EarningsState(
              status: EarningsStatus.ready,
              items: _buildItems(value),
            ),
          );
        case Err():
          emit(state.copyWith(refreshFailed: true));
      }
    } finally {
      _fetching = false;
      event.completer?.complete();
    }
  }

  void _onUpdate(EarningsUpdateReceived event, Emitter<EarningsState> emit) {
    final e = event.earning;
    if (_fetching) _buffer.add(e);
    if (state.status == EarningsStatus.ready && _ids.add(e.id)) {
      emit(state.copyWith(items: [_toItem(e), ...state.items]));
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
