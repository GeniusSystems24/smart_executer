import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/scenarios/product_cards/domain/entities/demo_product.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

/// Owns product state and operations for the product-cards view.
final class ProductCardsController extends ChangeNotifier {
  ProductCardsController({required DemoHttpClient client}) : _client = client;

  final DemoHttpClient _client;
  final List<DemoProduct> _products = [];
  final Set<int> _favorites = {};
  final Map<int, int> _cart = {};

  bool _isLoading = true;
  SmartException? _error;

  List<DemoProduct> get products => List.unmodifiable(_products);
  Set<int> get favorites => Set.unmodifiable(_favorites);
  Map<int, int> get cart => Map.unmodifiable(_cart);
  bool get isLoading => _isLoading;
  SmartException? get error => _error;
  int get cartItemCount => _cart.values.fold(0, (sum, value) => sum + value);

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
      () => _client.get('/posts', queryParameters: {'_limit': 12}),
    );

    result.fold(
      onSuccess: (response) {
        _products
          ..clear()
          ..addAll(
            (response.data as List<dynamic>).map(
              (json) => DemoProduct.fromJson(json as Map<String, dynamic>),
            ),
          );
      },
      onFailure: (exception) => _error = exception,
    );
    _isLoading = false;
    notifyListeners();
  }

  bool toggleFavorite(DemoProduct product) {
    final added = !_favorites.remove(product.id);
    if (added) _favorites.add(product.id);
    notifyListeners();
    return added;
  }

  void addToCart(DemoProduct product) {
    _cart[product.id] = (_cart[product.id] ?? 0) + 1;
    notifyListeners();
  }

  Future<int?> buyNow(BuildContext context, DemoProduct product) async {
    final response = await SmartExecuter.run<DemoHttpResponse<Map<String, dynamic>>>(
      request: () async {
        await Future<void>.delayed(const Duration(seconds: 1));
        return DemoHttpResponse<Map<String, dynamic>>(
          data: {'orderId': DateTime.now().millisecondsSinceEpoch},
          statusCode: 200,
        );
      },
      context: context,
      options: ExecuterOptions(
        operationName: 'buyProduct',
        metadata: {'productId': product.id, 'price': product.price},
      ),
    );
    return response?.data['orderId'] as int?;
  }
}
