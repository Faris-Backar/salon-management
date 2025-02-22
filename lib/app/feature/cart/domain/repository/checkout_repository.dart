import 'package:dartz/dartz.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/feature/cart/domain/entities/bill_entities.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, Unit>> checkout({required BillEntities bill});
}
