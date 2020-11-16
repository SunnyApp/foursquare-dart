import 'api.dart';

class Category {
  Category({this.categoryId, this.name});

  final String categoryId;
  final String name;

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Category(
        categoryId: json['id'] as String,
        name: json['name'] as String,
      );
    } else {
      return null;
    }
  }
}
