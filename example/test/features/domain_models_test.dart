import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer_example/features/scenarios/product_cards/domain/entities/demo_product.dart';
import 'package:smart_executer_example/features/scenarios/user_list/domain/entities/demo_user.dart';

void main() {
  test('DemoUser maps transport data without UI dependencies', () {
    final user = DemoUser.fromJson({
      'id': 3,
      'name': 'Ada',
      'email': 'ada@example.com',
      'company': {'name': 'Analytical Engines'},
    });

    expect(user.id, 3);
    expect(user.name, 'Ada');
    expect(user.company, 'Analytical Engines');
  });

  test('DemoProduct derives stable showcase values from its id', () {
    final product = DemoProduct.fromJson({
      'id': 2,
      'title': 'Demo',
      'body': 'Description',
    });

    expect(product.price, closeTo(19.98, 0.0001));
    expect(product.category, 'Category 3');
    expect(product.image, contains('/2/'));
  });
}
