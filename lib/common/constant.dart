part of 'global.dart';

class Constant {
  static double radius = 12.0;
  static double buttomSheetRadius = 28.0;
  static double smallPadding = 8.0;
  static double padding = 16.0;
  static double largePadding = 24.0;
  static double margin = 8.0;

  static double buttomHight = 320;
  static double buttomLetterSpacing = 4.0;

  static double iconSize = 24;
  static double iconlargeSize = 32;
  static int maxAmount = 99999999; //最大金额为100万减一 存储单位为分
  static int minYear = 2000;
  static int maxYear = 2050;
  static DateTime minDateTime = DateTime(minYear);
  static DateTime maxDateTime = DateTime(maxYear);

  static String defultLocation = 'Asia/Shanghai';
  static init() {
    radius = 12.0.sp;
    buttomSheetRadius = 28.0.sp;
    smallPadding = 8.0.sp;
    padding = 16.0.sp;
    largePadding = 24.0.sp;
    margin = 8.0.sp;
    buttomHight = 320.0.h;
    buttomLetterSpacing = 4.0.sp;
  }
}

class ConstantFontSize {
  const ConstantFontSize();
  static const double largeHeadline = 18;
  static const double headline = 16;

  static const double bodyLarge = 16;
  static const double body = 14;
  static const double bodySmall = 12;

  static const double letterSpacing = 2;
  // static init() {
  //   largeHeadline = largeHeadline.sp;
  //   headline = headline.sp;
  //   bodyLarge = bodyLarge.sp;
  //   body = body.sp;
  //   bodySmall = bodySmall.sp;
  //   letterSpacing = letterSpacing.sp;
  // }
}

class ConstantWidget {
  // ignore: library_private_types_in_public_api
  static _ConstantWidgetDivider divider = _ConstantWidgetDivider();
  static const Widget activityIndicator = CircularProgressIndicator();
}

class ConstantDecoration {
  static Radius radius = Radius.circular(Constant.radius);
  static BorderRadius borderRadius = BorderRadius.all(Radius.circular(Constant.radius));
  static BorderRadius bottomSheetBorderRadius = BorderRadius.vertical(top: Radius.circular(Constant.buttomSheetRadius));
  //BoxDecoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: ConstantDecoration.borderRadius,
  );
  static BoxDecoration bottomSheet = BoxDecoration(
    color: Colors.white,
    borderRadius: bottomSheetBorderRadius,
  );
}

class _ConstantWidgetDivider {
  _ConstantWidgetDivider();
  final Divider list = Divider(
    color: ConstantColor.listDividerColor,
    height: 0.5.sp,
    thickness: 0.5.sp,
  );
  final Divider indented = Divider(
    color: ConstantColor.listDividerColor,
    indent: Constant.margin,
    endIndent: Constant.margin,
    height: 0.5.sp,
    thickness: 0.5.sp,
  );
}

class ConstantColor {
  static const Color primaryColor = Colors.blue;
  static const Color primary80AlphaColor = Color.fromRGBO(33, 150, 243, 0.8);
  static const Color secondaryColor = Color.fromRGBO(187, 222, 251, 1); // is Colors.blue.shade100
  static const Color incomeAmount = Colors.green;
  static const Color expenseAmount = Colors.red;
  static const Color incomeAmount80Alpha = Color.fromRGBO(76, 175, 80, 0.8);
  static const Color expenseAmount80Alpha = Color.fromRGBO(244, 67, 54, 0.8);
  static const Color shimmerBaseColor = Color.fromRGBO(224, 224, 224, 1);
  static const Color shimmerHighlightColor = Color.fromRGBO(245, 245, 245, 1);
  static const Color greyBackground = Color.fromRGBO(245, 245, 245, 1);
  static const Color greyText = Color.fromRGBO(158, 158, 158, 1);
  static const Color greyButton = Color.fromRGBO(238, 238, 238, 1);
  static const Color greyButtonIcon = Colors.grey;
  static const Color shadowColor = Color.fromRGBO(250, 250, 250, 1);
  static const Color listDividerColor = Color.fromRGBO(238, 238, 238, 1);

  static const Color secondaryTextColor = Color.fromRGBO(117, 117, 117, 1); // is Colors.grey.shade800
  static const Color borderColor = Color.fromRGBO(189, 189, 189, 1); // is Colors.grey.shade400
}

class Constantlimit {
  static const int maxTimeRangeForYear = 2;
}

class ConstantIcon {
  static const IconData add = Icons.add_circle_outline_rounded;
}
