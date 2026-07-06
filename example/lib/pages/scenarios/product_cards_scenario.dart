import 'package:smart_executer_example/features/scenarios/product_cards/domain/entities/demo_product.dart';

// Compatibility export. New code should import the feature-first path.
export 'package:smart_executer_example/features/scenarios/product_cards/presentation/pages/product_cards_scenario.dart';

/// Backward-compatible name for the former example model.
@Deprecated('Use DemoProduct from the feature domain layer.')
typedef Product = DemoProduct;
