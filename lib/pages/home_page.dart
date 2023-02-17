import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:store_getx/pages/controller/store_controller.dart';
import 'package:store_getx/pages/controller/theme_controller.dart';

import '../repository/repository.dart';
import 'controller/store_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Get.put<Dio>(Dio(
      BaseOptions(baseUrl: 'https://fakestoreapi.com/products'),
    ));
    Get.lazyPut<StoreRepository>(
      () => StoreRepositoryImp(
        Get.find(),
      ),
    );
    Get.lazyPut<StoreController>(
      () => StoreController(
        repository: Get.find(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Getx',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: const [IconTheme()],
      ),
      body: const Center(
        child: BuildHomeReponse(),
      ),
    );
  }
}

class BuildHomeReponse extends StatelessWidget {
  const BuildHomeReponse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(
      builder: (_) {
        final state = _.state;
        if (state.productsStatus == StoreRequest.requestInProgress) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state.productsStatus == StoreRequest.requestFailure) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Problema al cargar Productos'),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  _.getStoreProductsRequested();
                },
                child: const Text('Intenta nuevamente'),
              ),
            ],
          );
        }

        if (state.productsStatus == StoreRequest.unknown) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shop_outlined,
                size: 60,
                color: Colors.black26,
              ),
              const SizedBox(height: 10),
              const Text('No se encontraron productos'),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  _.getStoreProductsRequested();
                },
                child: const Text('Cargar productos'),
              ),
            ],
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            final inCart = state.cartIds.contains(product.id);

            return Card(
              key: ValueKey(product.id),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Flexible(
                      child: Image.network(product.image),
                    ),
                    Text(
                      product.title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    inCart
                        ? OutlinedButton.icon(
                            icon:
                                const Icon(Icons.remove_shopping_cart_outlined),
                            onPressed: () =>
                                _.productsRemovedFromCart(product.id),
                            style: ButtonStyle(
                              backgroundColor: inCart
                                  ? const MaterialStatePropertyAll<Color>(
                                      Colors.black12)
                                  : null,
                            ),
                            label: Text(
                              'Eliminar del carrito',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                        : OutlinedButton.icon(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () => _.productsAddedToCart(product.id),
                            style: ButtonStyle(
                              backgroundColor: inCart
                                  ? const MaterialStatePropertyAll<Color>(
                                      Colors.black12)
                                  : null,
                            ),
                            label: Text(
                              'Agregar al carrito',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class IconTheme extends StatelessWidget {
  const IconTheme({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (theme) {
      return IconButton(
        onPressed: () => theme.changeTheme(),
        icon: const Icon(
          Icons.sunny,
        ),
      );
    });
  }
}
