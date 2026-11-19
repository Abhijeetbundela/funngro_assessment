import 'package:equatable/equatable.dart';

class Project extends Equatable {
  const Project({
    required this.id,
    required this.title,
    required this.company,
    required this.payout,
  });

  final String id;
  final String title;
  final String company;
  final int payout;

  @override
  List<Object?> get props => [id, title, company, payout];
}
