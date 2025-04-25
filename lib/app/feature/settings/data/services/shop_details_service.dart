import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/settings/domain/models/shop_details_model.dart';

class ShopDetailsService {
  static const String _collectionName = 'shop_details';
  static const String _documentId =
      'primary'; // Single document for shop details

  final FirebaseFirestore _firestore;

  ShopDetailsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveShopDetails(ShopDetailsModel details) async {
    await _firestore
        .collection(_collectionName)
        .doc(_documentId)
        .set(details.toJson());
  }

  Future<ShopDetailsModel?> getShopDetails() async {
    try {
      final doc =
          await _firestore.collection(_collectionName).doc(_documentId).get();

      if (doc.exists && doc.data() != null) {
        return ShopDetailsModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> clearShopDetails() async {
    await _firestore.collection(_collectionName).doc(_documentId).delete();
  }

  // Stream for real-time updates
  Stream<ShopDetailsModel?> shopDetailsStream() {
    return _firestore
        .collection(_collectionName)
        .doc(_documentId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return ShopDetailsModel.fromJson(doc.data()!);
      }
      return null;
    });
  }
}

final shopDetailsServiceProvider = Provider<ShopDetailsService>((ref) {
  return ShopDetailsService();
});

// FutureProvider for one-time retrieval (useful for most screens)
final shopDetailsProvider = FutureProvider<ShopDetailsModel>((ref) async {
  final service = ref.watch(shopDetailsServiceProvider);
  final shopDetails = await service.getShopDetails();
  return shopDetails ?? defaultShopDetails;
});

// StreamProvider for reactive updates (useful for real-time changes)
final shopDetailsStreamProvider = StreamProvider<ShopDetailsModel>((ref) {
  final service = ref.watch(shopDetailsServiceProvider);
  return service
      .shopDetailsStream()
      .map((details) => details ?? defaultShopDetails);
});

// Default shop details for new installations
final defaultShopDetails = ShopDetailsModel(
  name: 'My Salon',
  mobileNumber: '',
  address: '',
  slogan: 'Beauty at its best',
);
