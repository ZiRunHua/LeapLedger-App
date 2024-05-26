part of 'global.dart';

class Constant {
  static const double radius = 12.0;
  static const double buttomSheetRadius = 28.0;
  static const double smallPadding = 8.0;
  static const double padding = 16.0;
  static const double largePadding = 24.0;
  static const double margin = 8.0;

  static const double buttomLetterSpacing = 4.0;

  static const double iconSize = 24;

  static const int maxAmount = 99999999; //最大金额为100万减一 存储单位为分
  static const int minYear = 2000;
  static const int maxYear = 2050;
  static DateTime minDateTime = DateTime(minYear);
  static DateTime maxDateTime = DateTime(maxYear);
}

class ConstantFontSize {
  const ConstantFontSize();
  static const double largeHeadline = 18;
  static const double headline = 16;

  static const double bodyLarge = 16;
  static const double body = 14;
  static const double bodySmall = 12;

  static const double letterSpacing = 2;
}

class ConstantWidget {
  // ignore: library_private_types_in_public_api
  static const _ConstantWidgetDivider divider = _ConstantWidgetDivider();
  static const Widget activityIndicator = CircularProgressIndicator();
}

class ConstantDecoration {
  static const Radius radius = Radius.circular(Constant.radius);
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(Constant.radius));
  static const BorderRadius bottomSheetBorderRadius =
      BorderRadius.vertical(top: Radius.circular(Constant.buttomSheetRadius));
  //BoxDecoration
  static const BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: ConstantDecoration.borderRadius,
  );
  static const BoxDecoration bottomSheet = BoxDecoration(
    color: Colors.white,
    borderRadius: bottomSheetBorderRadius,
  );
}

class _ConstantWidgetDivider {
  const _ConstantWidgetDivider();
  final Divider list = const Divider(
    color: ConstantColor.listDividerColor,
    height: 0.5,
    thickness: 0.5,
  );
  final Divider indented = const Divider(
    color: ConstantColor.listDividerColor,
    indent: Constant.margin,
    endIndent: Constant.margin,
    height: 0.5,
    thickness: 0.5,
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
  static const Color listDividerColor = Color.fromRGBO(238, 238, 238, 1);

  static const Color secondaryTextColor = Color.fromRGBO(117, 117, 117, 1); // is Colors.grey.shade800
  static const Color borderColor = Color.fromRGBO(189, 189, 189, 1); // is Colors.grey.shade400
}

class Constantlimit {
  static const int maxTimeRangeForYear = 2;
}
