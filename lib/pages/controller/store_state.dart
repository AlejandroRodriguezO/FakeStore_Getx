import 'package:equatable/equatable.dart';

import '../../model/product.dart';

enum StoreRequest {
  unknown,
  requestInProgress,
  requestSuccess,
  requestFailure,
}

class StoreState extends Equatable {
  final List<Product> products;
  final StoreRequest productsStatus;
  final Set<int> cartIds;

  const StoreState({
    this.products = const [],
    this.productsStatus = StoreRequest.unknown,
    this.cartIds = const {},
  });

  @override
  List<Object?> get props => [
        products,
        productsStatus,
        cartIds,
      ];

  StoreState copyWith({
    List<Product>? products,
    StoreRequest? productsStatus,
    Set<int>? cartIds,
  }) =>
      StoreState(
        products: products ?? this.products,
        productsStatus: productsStatus ?? this.productsStatus,
        cartIds: cartIds ?? this.cartIds,
      );
}
