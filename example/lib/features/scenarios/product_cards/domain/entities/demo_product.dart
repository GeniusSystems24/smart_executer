final class DemoProduct {
  const DemoProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
    required this.reviewCount,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String image;
  final double rating;
  final int reviewCount;

  factory DemoProduct.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? 1;
    return DemoProduct(
      id: id,
      title: json['title'] as String? ?? 'Product',
      description: json['body'] as String? ?? 'No description available',
      price: id * 9.99,
      category: 'Category ${id % 5 + 1}',
      image: 'https://picsum.photos/seed/$id/200/200',
      rating: 3.5 + (id % 15) / 10,
      reviewCount: id * 12,
    );
  }
}
