class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isDefault,
    this.itemsCount = 0,
  });

  final int id;
  final String name;
  final String description;
  final bool isDefault;
  final int itemsCount;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isDefault: json['user_id'] == null,
      itemsCount: json['reading_lists_count'] as int? ?? 0,
    );
  }
}
