// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i21;
import 'package:flutter/material.dart' as _i23;
import 'package:salon_management/app/feature/auth/presentation/pages/login_screen.dart'
    as _i12;
import 'package:salon_management/app/feature/auth/presentation/pages/register_screen.dart'
    as _i13;
import 'package:salon_management/app/feature/category/presentation/pages/category_screen.dart'
    as _i1;
import 'package:salon_management/app/feature/category/presentation/pages/create_category_screen.dart'
    as _i2;
import 'package:salon_management/app/feature/customer/presentation/pages/customer_create_screen.dart'
    as _i5;
import 'package:salon_management/app/feature/customer/presentation/pages/customer_detailed_view.dart'
    as _i6;
import 'package:salon_management/app/feature/customer/presentation/pages/customer_screen.dart'
    as _i7;
import 'package:salon_management/app/feature/employee/presentation/pages/create_employee_screen.dart'
    as _i3;
import 'package:salon_management/app/feature/employee/presentation/pages/employee_screen.dart'
    as _i9;
import 'package:salon_management/app/feature/home/presentation/pages/dashboard.dart'
    as _i8;
import 'package:salon_management/app/feature/home/presentation/pages/home_screen.dart'
    as _i11;
import 'package:salon_management/app/feature/reports/presentation/pages/report_screen.dart'
    as _i15;
import 'package:salon_management/app/feature/service_items/domain/enitites/service_item_entity.dart'
    as _i22;
import 'package:salon_management/app/feature/service_items/presentation/pages/create_service_item_screen.dart'
    as _i4;
import 'package:salon_management/app/feature/service_items/presentation/pages/service_items_screen.dart'
    as _i16;
import 'package:salon_management/app/feature/settings/presentation/pages/expenses_screen.dart'
    as _i10;
import 'package:salon_management/app/feature/settings/presentation/pages/registered_users_screen.dart'
    as _i14;
import 'package:salon_management/app/feature/settings/presentation/pages/settings_screen.dart'
    as _i17;
import 'package:salon_management/app/feature/settings/presentation/pages/shop_details_screen.dart'
    as _i18;
import 'package:salon_management/app/feature/splash/presentation/pages/splash_screen.dart'
    as _i19;
import 'package:salon_management/app/feature/transactions/presentations/pages/transaction_screen.dart'
    as _i20;

/// generated route for
/// [_i1.CategoryScreen]
class CategoryRoute extends _i21.PageRouteInfo<void> {
  const CategoryRoute({List<_i21.PageRouteInfo>? children})
    : super(CategoryRoute.name, initialChildren: children);

  static const String name = 'CategoryRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i1.CategoryScreen();
    },
  );
}

/// generated route for
/// [_i2.CreateCategoryScreen]
class CreateCategoryRoute extends _i21.PageRouteInfo<void> {
  const CreateCategoryRoute({List<_i21.PageRouteInfo>? children})
    : super(CreateCategoryRoute.name, initialChildren: children);

  static const String name = 'CreateCategoryRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateCategoryScreen();
    },
  );
}

/// generated route for
/// [_i3.CreateEmployeeScreen]
class CreateEmployeeRoute extends _i21.PageRouteInfo<void> {
  const CreateEmployeeRoute({List<_i21.PageRouteInfo>? children})
    : super(CreateEmployeeRoute.name, initialChildren: children);

  static const String name = 'CreateEmployeeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i3.CreateEmployeeScreen();
    },
  );
}

/// generated route for
/// [_i4.CreateServiceItemScreen]
class CreateServiceItemRoute
    extends _i21.PageRouteInfo<CreateServiceItemRouteArgs> {
  CreateServiceItemRoute({
    required _i22.ServiceItemEntity? serviceItemEntity,
    _i23.Key? key,
    List<_i21.PageRouteInfo>? children,
  }) : super(
         CreateServiceItemRoute.name,
         args: CreateServiceItemRouteArgs(
           serviceItemEntity: serviceItemEntity,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'CreateServiceItemRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateServiceItemRouteArgs>();
      return _i4.CreateServiceItemScreen(args.serviceItemEntity, key: args.key);
    },
  );
}

class CreateServiceItemRouteArgs {
  const CreateServiceItemRouteArgs({required this.serviceItemEntity, this.key});

  final _i22.ServiceItemEntity? serviceItemEntity;

  final _i23.Key? key;

  @override
  String toString() {
    return 'CreateServiceItemRouteArgs{serviceItemEntity: $serviceItemEntity, key: $key}';
  }
}

/// generated route for
/// [_i5.CustomerCreateScreen]
class CustomerCreateRoute extends _i21.PageRouteInfo<void> {
  const CustomerCreateRoute({List<_i21.PageRouteInfo>? children})
    : super(CustomerCreateRoute.name, initialChildren: children);

  static const String name = 'CustomerCreateRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i5.CustomerCreateScreen();
    },
  );
}

/// generated route for
/// [_i6.CustomerDetailsScreen]
class CustomerDetailsRoute extends _i21.PageRouteInfo<void> {
  const CustomerDetailsRoute({List<_i21.PageRouteInfo>? children})
    : super(CustomerDetailsRoute.name, initialChildren: children);

  static const String name = 'CustomerDetailsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i6.CustomerDetailsScreen();
    },
  );
}

/// generated route for
/// [_i7.CustomerScreen]
class CustomerRoute extends _i21.PageRouteInfo<void> {
  const CustomerRoute({List<_i21.PageRouteInfo>? children})
    : super(CustomerRoute.name, initialChildren: children);

  static const String name = 'CustomerRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i7.CustomerScreen();
    },
  );
}

/// generated route for
/// [_i8.DashboardScreen]
class DashboardRoute extends _i21.PageRouteInfo<void> {
  const DashboardRoute({List<_i21.PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i8.DashboardScreen();
    },
  );
}

/// generated route for
/// [_i9.EmployeeScreen]
class EmployeeRoute extends _i21.PageRouteInfo<void> {
  const EmployeeRoute({List<_i21.PageRouteInfo>? children})
    : super(EmployeeRoute.name, initialChildren: children);

  static const String name = 'EmployeeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i9.EmployeeScreen();
    },
  );
}

/// generated route for
/// [_i10.ExpensesScreen]
class ExpensesRoute extends _i21.PageRouteInfo<void> {
  const ExpensesRoute({List<_i21.PageRouteInfo>? children})
    : super(ExpensesRoute.name, initialChildren: children);

  static const String name = 'ExpensesRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i10.ExpensesScreen();
    },
  );
}

/// generated route for
/// [_i11.HomeScreen]
class HomeRoute extends _i21.PageRouteInfo<void> {
  const HomeRoute({List<_i21.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomeScreen();
    },
  );
}

/// generated route for
/// [_i12.LoginScreen]
class LoginRoute extends _i21.PageRouteInfo<void> {
  const LoginRoute({List<_i21.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i12.LoginScreen();
    },
  );
}

/// generated route for
/// [_i13.RegisterScreen]
class RegisterRoute extends _i21.PageRouteInfo<void> {
  const RegisterRoute({List<_i21.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i13.RegisterScreen();
    },
  );
}

/// generated route for
/// [_i14.RegisteredUsersScreen]
class RegisteredUsersRoute extends _i21.PageRouteInfo<void> {
  const RegisteredUsersRoute({List<_i21.PageRouteInfo>? children})
    : super(RegisteredUsersRoute.name, initialChildren: children);

  static const String name = 'RegisteredUsersRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i14.RegisteredUsersScreen();
    },
  );
}

/// generated route for
/// [_i15.ReportScreen]
class ReportRoute extends _i21.PageRouteInfo<void> {
  const ReportRoute({List<_i21.PageRouteInfo>? children})
    : super(ReportRoute.name, initialChildren: children);

  static const String name = 'ReportRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i15.ReportScreen();
    },
  );
}

/// generated route for
/// [_i16.ServiceItemsScreen]
class ServiceItemsRoute extends _i21.PageRouteInfo<void> {
  const ServiceItemsRoute({List<_i21.PageRouteInfo>? children})
    : super(ServiceItemsRoute.name, initialChildren: children);

  static const String name = 'ServiceItemsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i16.ServiceItemsScreen();
    },
  );
}

/// generated route for
/// [_i17.SettingsScreen]
class SettingsRoute extends _i21.PageRouteInfo<void> {
  const SettingsRoute({List<_i21.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i17.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i18.ShopDetailsScreen]
class ShopDetailsRoute extends _i21.PageRouteInfo<void> {
  const ShopDetailsRoute({List<_i21.PageRouteInfo>? children})
    : super(ShopDetailsRoute.name, initialChildren: children);

  static const String name = 'ShopDetailsRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i18.ShopDetailsScreen();
    },
  );
}

/// generated route for
/// [_i19.SplashScreen]
class SplashRoute extends _i21.PageRouteInfo<void> {
  const SplashRoute({List<_i21.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i19.SplashScreen();
    },
  );
}

/// generated route for
/// [_i20.TransactionScreen]
class TransactionRoute extends _i21.PageRouteInfo<void> {
  const TransactionRoute({List<_i21.PageRouteInfo>? children})
    : super(TransactionRoute.name, initialChildren: children);

  static const String name = 'TransactionRoute';

  static _i21.PageInfo page = _i21.PageInfo(
    name,
    builder: (data) {
      return const _i20.TransactionScreen();
    },
  );
}
