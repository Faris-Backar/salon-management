class ServiceItemEntity {
  final String uid;
  final String name;
  final String price;
  final bool isActive;

  ServiceItemEntity(
      {required this.uid,
      required this.name,
      required this.price,
      required this.isActive});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'price': price,
      'isActive': isActive,
    };
  }
}
