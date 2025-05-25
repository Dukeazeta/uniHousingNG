class CategoryModel {
  final String name;
  final String icon;
  final int count;

  const CategoryModel({
    required this.name,
    required this.icon,
    required this.count,
  });

  CategoryModel copyWith({
    String? name,
    String? icon,
    int? count,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
      'count': count,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }
}
