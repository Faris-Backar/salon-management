// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:flutter/material.dart' as _i18;
import 'package:salon_management/app/feature/auth/presentation/pages/login_screen.dart'
    as _i10;
import 'package:salon_management/app/feature/category/presentation/pages/category_screen.dart'
    as _i1;
import 'package:salon_management/app/feature/category/presentation/pages/create_category_screen.dart'
    as _i2;
import 'package:salon_management/app/feature/customer/presentation/pages/customer_create_screen.dart'
    as _i4;
import 'package:salon_management/app/feature/customer/presentation/pages/customer_detailed_view.dart'
    as _i5;
import 'package:salon_management/app/feature/customer/presentation/pages/customer_screen.dart'
    as _i6;
import 'package:salon_management/app/feature/employee/presentation/pages/employee_screen.dart'
    as _i8;
import 'package:salon_management/app/feature/home/presentation/pages/dashboard.dart'
    as _i7;
import 'package:salon_management/app/feature/home/presentation/pages/home_screen.dart'
    as _i9;
import 'package:salon_management/app/feature/reports/presentation/pages/report_screen.dart'
    as _i11;
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart'
    as _i17;
import 'package:salon_management/app/feature/service_items/presentation/pages/create_service_item_screen.dart'
    as _i3;
import 'package:salon_management/app/feature/service_items/presentation/pages/service_items_screen.dart'
    as _i12;
import 'package:salon_management/app/feature/settings/presentation/pages/settings_screen.dart'
    as _i13;
import 'package:salon_management/app/feature/splash/presentation/pages/splash_screen.dart'
    as _i14;
import 'package:salon_management/app/feature/transactions/presentations/pages/transaction_screen.dart'
    as _i15;

/// generated route for
/// [_i1.CategoryScreen]
class CategoryRoute extends _i16.PageRouteInfo<void> {
  const CategoryRoute({List<_i16.PageRouteInfo>? children})
    : super(CategoryRoute.name, initialChildren: children);

  static const String name = 'CategoryRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i1.CategoryScreen();
    },
  );
}

/// generated route for
/// [_i2.CreateCategoryScreen]
class CreateCategoryRoute extends _i16.PageRouteInfo<void> {
  const CreateCategoryRoute({List<_i16.PageRouteInfo>? children})
    : super(CreateCategoryRoute.name, initialChildren: children);

  static const String name = 'CreateCategoryRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateCategoryScreen();
    },
  );
}

/// generated route for
/// [_i3.CreateServiceItemScreen]
class CreateServiceItemRoute
    extends _i16.PageRouteInfo<CreateServiceItemRouteArgs> {
  CreateServiceItemRoute({
    required _i17.ServiceItemEntity? serviceItemEntity,
    _i18.Key? key,
    List<_i16.PageRouteInfo>? children,
  }) : super(
         CreateServiceItemRoute.name,
         args: CreateServiceItemRouteArgs(
           serviceItemEntity: serviceItemEntity,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'CreateServiceItemRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateServiceItemRouteArgs>();
      return _i3.CreateServiceItemScreen(args.serviceItemEntity, key: args.key);
    },
  );
}

class CreateServiceItemRouteArgs {
  const CreateServiceItemRouteArgs({required this.serviceItemEntity, this.key});

  final _i17.ServiceItemEntity? serviceItemEntity;

  final _i18.Key? key;

  @override
  String toString() {
    return 'CreateServiceItemRouteArgs{serviceItemEntity: $serviceItemEntity, key: $key}';
  }
}

/// generated route for
/// [_i4.CustomerCreateScreen]
class CustomerCreateRoute extends _i16.PageRouteInfo<void> {
  const CustomerCreateRoute({List<_i16.PageRouteInfo>? children})
    : super(CustomerCreateRoute.name, initialChildren: children);

  static const String name = 'CustomerCreateRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i4.CustomerCreateScreen();
    },
  );
}

/// generated route for
/// [_i5.CustomerDetailsScreen]
class CustomerDetailsRoute extends _i16.PageRouteInfo<void> {
  const CustomerDetailsRoute({List<_i16.PageRouteInfo>? children})
    : super(CustomerDetailsRoute.name, initialChildren: children);

  static const String name = 'CustomerDetailsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i5.CustomerDetailsScreen();
    },
  );
}

/// generated route for
/// [_i6.CustomerScreen]
class CustomerRoute extends _i16.PageRouteInfo<void> {
  const CustomerRoute({List<_i16.PageRouteInfo>? children})
    : super(CustomerRoute.name, initialChildren: children);

  static const String name = 'CustomerRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i6.CustomerScreen();
    },
  );
}

/// generated route for
/// [_i7.DashboardScreen]
class DashboardRoute extends _i16.PageRouteInfo<void> {
  const DashboardRoute({List<_i16.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i7.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i8.EmployeeScreen]
class EmployeeRoute extends _i16.PageRouteInfo<void> {
  const EmployeeRoute({List<_i16.PageRouteInfo>? children})
    : super(EmployeeRoute.name, initialChildren: children);

  static const String name = 'EmployeeRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i8.EmployeeScreen();
    },
  );
}

/// generated route for
/// [_i9.HomeScreen]
class HomeRoute extends _i16.PageRouteInfo<void> {
  const HomeRoute({List<_i16.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i9.HomeScreen();
    },
  );
}

/// generated route for
/// [_i10.LoginScreen]
class LoginRoute extends _i16.PageRouteInfo<void> {
  const LoginRoute({List<_i16.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i10.LoginScreen();
    },
  );
}

/// generated route for
/// [_i11.ReportScreen]
class ReportRoute extends _i16.PageRouteInfo<void> {
  const ReportRoute({List<_i16.PageRouteInfo>? children})
    : super(ReportRoute.name, initialChildren: children);

  static const String name = 'ReportRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i11.ReportScreen();
    },
  );
}

/// generated route for
/// [_i12.ServiceItemsScreen]
class ServiceItemsRoute extends _i16.PageRouteInfo<void> {
  const ServiceItemsRoute({List<_i16.PageRouteInfo>? children})
    : super(ServiceItemsRoute.name, initialChildren: children);

  static const String name = 'ServiceItemsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i12.ServiceItemsScreen();
    },
  );
}

/// generated route for
/// [_i13.SettingsScreen]
class SettingsRoute extends _i16.PageRouteInfo<void> {
  const SettingsRoute({List<_i16.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i13.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i14.SplashScreen]
class SplashRoute extends _i16.PageRouteInfo<void> {
  const SplashRoute({List<_i16.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i14.SplashScreen();
    },
  );
}

/// generated route for
/// [_i15.TransactionScreen]
class TransactionRoute extends _i16.PageRouteInfo<void> {
  const TransactionRoute({List<_i16.PageRouteInfo>? children})
    : super(TransactionRoute.name, initialChildren: children);

  static const String name = 'TransactionRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i15.TransactionScreen();
    },
  );
}
