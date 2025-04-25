import 'package:auto_route/auto_route.dart';
import 'package:salon_management/app/core/resources/pref_resources.dart';
import 'package:salon_management/app/core/routes/app_router.gr.dart';
import 'package:shared_preferences/shared_preferences.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true, path: splashScreen),
        AutoRoute(page: LoginRoute.page, path: loginScreen),
        AutoRoute(page: CreateCategoryRoute.page, path: createCategoryScreen),
        AutoRoute(page: CreateServiceItemRoute.page, path: createServiceScreen),
        AutoRoute(
          page: DashboardRoute.page,
          path: dashBoardScreen,
          guards: [AuthGuard()],
          children: [
            AutoRoute(
              page: HomeRoute.page,
              path: homeScreen,
            ),
            AutoRoute(
              page: TransactionRoute.page,
              path: transactionScreen,
            ),
            AutoRoute(
              page: EmployeeRoute.page,
              path: employeeScreen,
            ),
            AutoRoute(
              page: CustomerRoute.page,
              path: customerScreen,
            ),
            AutoRoute(
              page: ServiceItemsRoute.page,
              path: serviceScreen,
            ),
            AutoRoute(
              page: ReportRoute.page,
              path: reportScreen,
            ),
            AutoRoute(
              page: CategoryRoute.page,
              path: categoryScreen,
            ),
            AutoRoute(
              page: CustomerCreateRoute.page,
              path: createCustomer,
            ),
            AutoRoute(
              page: CustomerDetailsRoute.page,
              path: customerDetailsScreen,
            ),
            AutoRoute(
              page: SettingsRoute.page,
              path: settings,
            ),
            AutoRoute(
              page: ExpensesRoute.page,
              path: expenses,
            ),
            AutoRoute(
              page: ShopDetailsRoute.page,
              path: shopDetails,
            ),
          ],
        ),
      ];

  static const String splashScreen = "/splash";
  static const String homeScreen = "home";
  static const String loginScreen = "/login";
  static const String dashBoardScreen = "/dashboard";
  static const String employeeScreen = "employee";
  static const String customerScreen = "customer";
  static const String serviceScreen = "service";
  static const String createServiceScreen = "/create_service";
  static const String createCategoryScreen = "/create_category";
  static const String categoryScreen = "category";
  static const String transactionScreen = "transaction";
  static const String reportScreen = "report";
  static const String createCustomer = "createCustomer";
  static const String customerDetailsScreen = "CustomerDetailsScreen";
  static const String settings = "settings";
  static const String expenses = "expenses";
  static const String shopDetails = 'shop-details';
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated =
        prefs.getBool(PrefResources.isAuthenticated) ?? false;
    if (isAuthenticated) {
      resolver.next();
    } else {
      router.replaceNamed(AppRouter.loginScreen);
    }
  }
}
