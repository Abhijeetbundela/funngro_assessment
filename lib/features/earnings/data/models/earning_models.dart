import 'package:funngro_assessment/features/earnings/domain/entities/earning.dart';

class EarningModel extends Earning {
  const EarningModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.createdAt,
  });

  factory EarningModel.fromJson(Map<String, dynamic> json) => EarningModel(
    id: json['id'] as String,
    title: json['title'] as String,
    amount: (json['amount'] as num).toDouble(),
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}

class EarningDetailModel extends EarningDetail {
  const EarningDetailModel({
    required super.id,
    required super.description,
    required super.status,
  });

  factory EarningDetailModel.fromJson(Map<String, dynamic> json) =>
      EarningDetailModel(
        id: json['id'] as String,
        description: json['description'] as String,
        status: json['status'] as String,
      );
}
