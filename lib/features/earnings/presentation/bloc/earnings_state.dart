part of 'earnings_bloc.dart';

enum EarningsStatus { loading, failure, ready }

final class EarningItem extends Equatable {
  const EarningItem({required this.earning, required this.amountLabel});
  final Earning earning;
  final String amountLabel;

  @override
  List<Object?> get props => [earning, amountLabel];
}

final class EarningsState extends Equatable {
  const EarningsState({
    this.status = EarningsStatus.loading,
    this.items = const [],
    this.message,
    this.refreshFailed = false,
  });

  final EarningsStatus status;
  final List<EarningItem> items;
  final String? message;
  final bool refreshFailed;

  EarningsState copyWith({List<EarningItem>? items, bool? refreshFailed}) {
    return EarningsState(
      status: status,
      items: items ?? this.items,
      message: message,
      refreshFailed: refreshFailed ?? this.refreshFailed,
    );
  }

  @override
  List<Object?> get props => [status, items, message, refreshFailed];
}
