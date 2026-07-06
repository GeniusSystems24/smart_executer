import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/app/app_dependencies.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/features/scenarios/product_cards/domain/entities/demo_product.dart';
import 'package:smart_executer_example/features/scenarios/product_cards/presentation/controllers/product_cards_controller.dart';
import 'package:smart_executer_example/shared/presentation/widgets/common_widgets.dart';
import 'package:tooltip_card/tooltip_card.dart';

/// Product cards demonstrating TooltipCard with SmartExecuter.
class ProductCardsScenario extends StatefulWidget {
  const ProductCardsScenario({super.key});

  @override
  State<ProductCardsScenario> createState() => _ProductCardsScenarioState();
}

class _ProductCardsScenarioState extends State<ProductCardsScenario> {
  late final ProductCardsController _controller;

  List<DemoProduct> get _products => _controller.products;
  bool get _isLoading => _controller.isLoading;
  SmartException? get _error => _controller.error;
  Set<int> get _favorites => _controller.favorites;
  Map<int, int> get _cart => _controller.cart;

  @override
  void initState() {
    super.initState();
    _controller = ProductCardsController(
      client: AppDependencies.createHttpClient(),
    )..addListener(_refreshView);
    _controller.loadProducts();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refreshView)
      ..dispose();
    super.dispose();
  }

  void _refreshView() {
    if (mounted) setState(() {});
  }

  Future<void> _loadProducts() => _controller.loadProducts();

  void _toggleFavorite(DemoProduct product) {
    final added = _controller.toggleFavorite(product);
    SmartSnackBars.showSuccess(
      context,
      added ? 'Added to favorites' : 'Removed from favorites',
    );
  }

  void _addToCart(DemoProduct product) {
    _controller.addToCart(product);
    final safeLength = product.title.length.clamp(0, 20).toInt();
    SmartSnackBars.showSuccess(
      context,
      '${product.title.substring(0, safeLength)}... added to cart',
    );
  }

  Future<void> _buyNow(DemoProduct product) async {
    final orderId = await _controller.buyNow(context, product);
    if (!mounted || orderId == null) return;
    _showPurchaseSuccess(product, orderId);
  }

  void _showPurchaseSuccess(DemoProduct product, int orderId) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 48,
        ),
        title: const Text('Order Placed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order #$orderId'),
            const SizedBox(height: 8),
            Text(
              'Total: \$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: GradientHeader(
              title: 'Product Cards',
              subtitle: 'TooltipCard + SmartExecuter integration',
              icon: Icons.shopping_bag,
            ),
          ),

          // Cart summary
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.shopping_cart, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Cart: ${_cart.values.fold(0, (a, b) => a + b)} items',
                    style: AppTextStyles.labelLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _loadProducts,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: SmartLoadingCard(
                  title: 'Loading Products',
                  message: 'Fetching product catalog...',
                ),
              ),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SmartErrorCard.fromException(
                  _error!,
                  action: 'Retry',
                  onActionPressed: _loadProducts,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = _products[index];
                    return _ProductCard(
                      product: product,
                      isFavorite: _favorites.contains(product.id),
                      cartQuantity: _cart[product.id] ?? 0,
                      onFavorite: () => _toggleFavorite(product),
                      onAddToCart: () => _addToCart(product),
                      onBuyNow: () => _buyNow(product),
                    );
                  },
                  childCount: _products.length,
                ),
              ),
            ),

          // Code preview
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Integration Code',
                    subtitle: 'TooltipCard with SmartExecuter',
                  ),
                  const CodePreview(
                    language: 'dart',
                    code: '''// Product card with tooltip
TooltipCard.builder(
  beakEnabled: true,
  placementSide: TooltipCardPlacementSide.top,
  modalBarrierEnabled: true,
  child: ProductImage(...),
  builder: (context, close) => TooltipCardContent(
    icon: Icon(Icons.shopping_bag),
    title: product.title,
    subtitle: '\\\${product.price}',
    primaryAction: FilledButton(
      onPressed: () async {
        close();
        // Buy with SmartExecuter
        await SmartExecuter.run(
          request: () => purchaseProduct(product),
          context: context,
          onSuccess: (r) => showSuccess(),
        );
      },
      child: Text('Buy Now'),
    ),
  ),
)''',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Product card with tooltip
class _ProductCard extends StatelessWidget {
  final DemoProduct product;
  final bool isFavorite;
  final int cartQuantity;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _ProductCard({
    required this.product,
    required this.isFavorite,
    required this.cartQuantity,
    required this.onFavorite,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return TooltipCard.builder(
      beakEnabled: true,
      placementSide: TooltipCardPlacementSide.top,
      modalBarrierEnabled: true,
      barrierBlur: 2.0,
      barrierColor: Colors.black26,
      elevation: 12,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.image, size: 48),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color:
                              isFavorite ? AppColors.error : AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                  // Cart badge
                  if (cartQuantity > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'x$cartQuantity',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: AppTextStyles.labelLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      builder: (context, close) => TooltipCardContent(
        icon: const Icon(Icons.shopping_bag),
        iconColor: AppColors.primary,
        title: product.title,
        subtitle: product.category,
        maxWidth: 320,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.description,
              style: AppTextStyles.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.star,
                  label:
                      '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                  color: Colors.amber,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.local_offer,
                  label: '\$${product.price.toStringAsFixed(2)}',
                  color: AppColors.success,
                ),
              ],
            ),
          ],
        ),
        primaryAction: FilledButton.icon(
          onPressed: () {
            close();
            onBuyNow();
          },
          icon: const Icon(Icons.flash_on, size: 18),
          label: const Text('Buy Now'),
        ),
        secondaryAction: OutlinedButton.icon(
          onPressed: () {
            close();
            onAddToCart();
          },
          icon: const Icon(Icons.add_shopping_cart, size: 18),
          label: const Text('Add to Cart'),
        ),
        onClose: close,
      ),
    );
  }
}

/// Info chip widget
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
