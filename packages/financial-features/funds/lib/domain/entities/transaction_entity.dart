import 'package:equatable/equatable.dart';

enum TransactionType { subscribe, cancel }

enum NotificationMethod { email, sms }

class TransactionEntity extends Equatable {
  const TransactionEntity({
    required this.id,
    required this.fundId,
    required this.fundName,
    required this.type,
    required this.amount,
    required this.date,
    required this.notificationMethod,
  });

  final String id;
  final String fundId;
  final String fundName;
  final TransactionType type;
  final int amount;
  final DateTime date;
  final NotificationMethod notificationMethod;

  @override
  List<Object?> get props => [
    id,
    fundId,
    fundName,
    type,
    amount,
    date,
    notificationMethod,
  ];
}
