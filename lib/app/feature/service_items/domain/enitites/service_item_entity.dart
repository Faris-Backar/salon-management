import 'dart:convert';

class ServiceItemEntity {
  final String uid;
  final String name;
  final String price;
  final String categoryName;
  final String categoryUid;
  final bool isActive;
  final String? remark;

  ServiceItemEntity(
      {required this.categoryName,
      required this.categoryUid,
      required this.uid,
      required this.name,
      required this.price,
      required this.isActive,
      this.remark});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'price': price,
      'categoryName': categoryName,
      'categoryUid': categoryUid,
      'isActive': isActive,
      'remark': remark,
    };
  }

  factory ServiceItemEntity.fromMap(Map<String, dynamic> map) {
    return ServiceItemEntity(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      categoryName: map['categoryName'] ?? '',
      categoryUid: map['categoryUid'] ?? '',
      isActive: map['isActive'] ?? false,
      remark: map['remark'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceItemEntity.fromJson(String source) =>
      ServiceItemEntity.fromMap(json.decode(source));

  ServiceItemEntity copyWith({
    String? uid,
    String? name,
    String? price,
    String? categoryName,
    String? categoryUid,
    bool? isActive,
    String? remark,
  }) {
    return ServiceItemEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryName: categoryName ?? this.categoryName,
      categoryUid: categoryUid ?? this.categoryUid,
      isActive: isActive ?? this.isActive,
      remark: remark ?? this.remark,
    );
  }
}
