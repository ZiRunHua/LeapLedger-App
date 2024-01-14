part of 'global.dart';

class Constant {
  static const double radius = 12.0;
  static const double smallPadding = 8.0;
  static const double padding = 16.0;
  static const double largePadding = 24.0;
  static const double margin = 8.0;

  static const double buttomLetterSpacing = 4.0;

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
  static const double body = 14;
  static const double bodySmall = 12;
}

class ConstantWidget {
  // ignore: library_private_types_in_public_api
  static const _ConstantWidgetDivider divider = _ConstantWidgetDivider();
}

class ConstantDecoration {
  static const Radius radius = Radius.circular(Constant.radius);
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(Constant.radius));
  //BoxDecoration
  static const BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: ConstantDecoration.borderRadius,
  );
  static const BoxDecoration bottomSheet = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: ConstantDecoration.radius,
      topRight: ConstantDecoration.radius,
    ),
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
  static const Color secondaryColor = Color.fromRGBO(187, 222, 251, 1);
  static const Color incomeAmount = Colors.green;
  static const Color expenseAmount = Colors.red;
  static const Color shimmerBaseColor = Color.fromRGBO(224, 224, 224, 1);
  static const Color shimmerHighlightColor = Color.fromRGBO(245, 245, 245, 1);
  static const Color greyBackground = Color.fromRGBO(245, 245, 245, 1);

  static const Color greyButton = Color.fromRGBO(238, 238, 238, 1);

  static const Color listDividerColor = Color.fromRGBO(238, 238, 238, 1);

  static const Color secondaryTextColor = Color.fromRGBO(117, 117, 117, 1);
}
