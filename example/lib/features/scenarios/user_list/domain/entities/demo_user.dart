final class DemoUser {
  const DemoUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.company,
  });

  final int id;
  final String name;
  final String email;
  final String avatar;
  final String company;

  factory DemoUser.fromJson(Map<String, dynamic> json) {
    return DemoUser(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: 'https://i.pravatar.cc/150?img=${json['id'] ?? 1}',
      company: (json['company'] as Map<String, dynamic>?)?['name'] as String? ??
          'Unknown',
    );
  }
}
