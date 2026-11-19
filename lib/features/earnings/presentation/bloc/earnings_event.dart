part of 'earnings_bloc.dart';

sealed class EarningsEvent extends Equatable {
  const EarningsEvent();

  @override
  List<Object?> get props => const [];
}

final class EarningsStarted extends EarningsEvent {
  const EarningsStarted();
}

final class EarningsRefreshed extends EarningsEvent {
  const EarningsRefreshed([this.completer]);
  final Completer<void>? completer;

  @override
  List<Object?> get props => [completer];
}

final class EarningsUpdateReceived extends EarningsEvent {
  const EarningsUpdateReceived(this.earning);
  final Earning earning;

  @override
  List<Object?> get props => [earning];
}
