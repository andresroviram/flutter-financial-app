import 'package:equatable/equatable.dart';

enum FundCategory { fpv, fic }

const Object _sentinel = Object();

class FundEntity extends Equatable {
  const FundEntity({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    this.isSubscribed = false,
    this.subscribedAmount,
  });

  final String id;
  final String name;
  final int minimumAmount; // COP
  final FundCategory category;
  final bool isSubscribed;
  final int? subscribedAmount;

  FundEntity copyWith({
    String? id,
    String? name,
    int? minimumAmount,
    FundCategory? category,
    bool? isSubscribed,
    Object? subscribedAmount = _sentinel,
  }) => FundEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    minimumAmount: minimumAmount ?? this.minimumAmount,
    category: category ?? this.category,
    isSubscribed: isSubscribed ?? this.isSubscribed,
    subscribedAmount: subscribedAmount == _sentinel
        ? this.subscribedAmount
        : subscribedAmount as int?,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    minimumAmount,
    category,
    isSubscribed,
    subscribedAmount,
  ];
}
