import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeUtils {
  static double getWidth(double width) {
    return ScreenUtil().setWidth(width);
  }

  static double getHeight(double height) {
    return ScreenUtil().setHeight(height);
  }

  static double getFont(double fontSize) {
    return ScreenUtil().setSp(fontSize);
  }

  static double getRadius(double radius) {
    return ScreenUtil().radius(radius);
  }

  static double getScreenWidth() {
    return ScreenUtil().screenWidth;
  }

  static double getScreenHeight() {
    return ScreenUtil().screenHeight;
  }
}
