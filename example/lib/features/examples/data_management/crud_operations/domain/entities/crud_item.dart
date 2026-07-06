final class CrudItem {
  const CrudItem({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CrudItem copyWith({String? name, DateTime? updatedAt}) {
    return CrudItem(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
