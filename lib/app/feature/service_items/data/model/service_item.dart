import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart';

class ServiceItem extends ServiceItemEntity {
  ServiceItem({
    required super.uid,
    required super.name,
    required super.price,
    required super.isActive,
    required super.categoryName,
    required super.categoryUid,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      uid: json['uid'],
      name: json['name'],
      price: json['price'],
      isActive: json['isActive'],
      categoryName: json['categoryName'],
      categoryUid: json['categoryUid'],
    );
  }
}
