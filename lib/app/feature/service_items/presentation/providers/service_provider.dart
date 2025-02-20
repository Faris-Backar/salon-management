import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_management/app/feature/auth/presentation/providers/auth_provider.dart';
import 'package:salon_management/app/feature/service_items/data/repositories/service_item_repository_impl.dart';
import 'package:salon_management/app/feature/service_items/domain/repositories/service_repository.dart';
import 'package:salon_management/app/feature/service_items/domain/usecase/service_item_usecase.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_item_notifiers.dart';
import 'package:salon_management/app/feature/service_items/presentation/providers/service_state.dart';

final serviceRepositoryProvider = Provider<ServiceItemsRepository>((ref) =>
    ServiceItemRepositoryImpl(firestore: ref.read(firebaseFirestoreProvider)));

final serviceItemUsecaseProvider = Provider(
  (ref) => ServiceItemUsecase(
      serviceItemRepository: ref.read(serviceRepositoryProvider)),
);

final serviceItemNotifierProvider =
    StateNotifierProvider<ServiceItemNotifier, ServiceItemState>(
  (ref) => ServiceItemNotifier(
    serviceItemUsecase: ref.read(serviceItemUsecaseProvider),
  ),
);
