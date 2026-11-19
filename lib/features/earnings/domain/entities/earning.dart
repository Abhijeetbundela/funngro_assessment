import 'package:equatable/equatable.dart';

class Earning extends Equatable {
  const Earning({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, title, amount, createdAt];
}

// detail page loads its own data
class EarningDetail extends Equatable {
  const EarningDetail({
    required this.id,
    required this.description,
    required this.status,
  });

  final String id;
  final String description;
  final String status;

  @override
  List<Object?> get props => [id, description, status];
}
