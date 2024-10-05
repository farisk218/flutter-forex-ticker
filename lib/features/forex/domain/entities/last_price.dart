import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final double currentPrice;
  final double timestamp;

  const Quote({
    required this.currentPrice,
    required this.timestamp,
  });

  @override
  List<Object> get props => [currentPrice, timestamp];

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      currentPrice: json['c'].toDouble(),
      timestamp: json['t'].toDouble(),
    );
  }

  Quote copyWith({
    double? currentPrice,
    double? timestamp,
  }) {
    return Quote(
      currentPrice: currentPrice ?? this.currentPrice,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
