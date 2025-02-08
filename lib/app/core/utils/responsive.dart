import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile() => 1.sw < mobile;

  static bool isTablet() => 1.sw >= mobile && 1.sw < tablet;

  static bool isDesktop() => 1.sw >= tablet;
}
