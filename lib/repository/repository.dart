import 'package:dio/dio.dart';

import '../model/product.dart';

abstract class StoreRepository {
  Future<List<Product>> getProducts();
}

class StoreRepositoryImp implements StoreRepository {
  final Dio client;

  StoreRepositoryImp(this.client);

  @override
  Future<List<Product>> getProducts() async {
    final response = await client.get('');

    return (response.data as List)
        .map((json) => Product.fromMap(json))
        .toList();
  }
}
