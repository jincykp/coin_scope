import 'package:equatable/equatable.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoinsEvent extends MarketEvent {
  const FetchCoinsEvent();
}

class RefreshCoinsEvent extends MarketEvent {
  const RefreshCoinsEvent();
}