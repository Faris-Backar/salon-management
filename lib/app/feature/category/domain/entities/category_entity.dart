class CategoryEntity {
  final String uid;
  final String name;
  final bool isActive;

  CategoryEntity(
      {required this.uid, required this.name, required this.isActive});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'isActive': isActive,
    };
  }
}
