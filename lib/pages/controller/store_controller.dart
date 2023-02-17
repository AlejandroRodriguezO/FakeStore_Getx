import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:store_getx/pages/controller/store_state.dart';

import '../../repository/repository.dart';

class StoreController extends GetxController {
  StoreController({required this.repository});

  final StoreRepository repository;

  StoreState state = const StoreState();

  Future<void> getStoreProductsRequested() async {
    try {
      state = state.copyWith(productsStatus: StoreRequest.requestInProgress);
      final response = await repository.getProducts();
      state = state.copyWith(
          products: response, productsStatus: StoreRequest.requestSuccess);
    } catch (e) {
      state = state.copyWith(productsStatus: StoreRequest.requestFailure);
    }
    update();
  }

  Future<void> productsAddedToCart(int id) async {
    state = state.copyWith(cartIds: {...state.cartIds, id});
    update();
  }

  Future<void> productsRemovedFromCart(int id) async {
    state = state.copyWith(cartIds: {...state.cartIds}..remove(id));
    update();
  }

  @override
  void onInit() {
    getStoreProductsRequested();
    super.onInit();
  }
}
