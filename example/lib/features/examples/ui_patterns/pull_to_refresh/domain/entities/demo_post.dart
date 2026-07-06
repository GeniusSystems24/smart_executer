final class DemoPost {
  const DemoPost({
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final String title;
  final String body;

  factory DemoPost.fromJson(Map<String, dynamic> json) {
    return DemoPost(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }
}
