part of 'enter.dart';

class Json {
  static DateTime dateTimeFromJson(dynamic timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp != null ? timestamp * 1000 + 28800000 : 0);
  }

  static int dateTimeToJson(DateTime? dateTime) {
    return dateTime != null ? dateTime.millisecondsSinceEpoch ~/ 1000 - 28800 : 0;
  }

  static DateTime? optionDateTimeFromJson(dynamic timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp != null ? timestamp * 1000 + 28800000 : null);
  }

  static int? optionDateTimeToJson(DateTime? dateTime) {
    return dateTime != null ? dateTime.millisecondsSinceEpoch ~/ 1000 - 28800 : null;
  }

  static const _defaultIconData = Icons.payment_outlined;

  static final Map<IconData, String> _reverseIconMap =
      Map.fromEntries(_iconMap.entries.map((entry) => MapEntry(entry.value, entry.key)));
  static iconDataFormJson(dynamic iconString) {
    if (iconString == null) {
      return _defaultIconData;
    }
    return _iconMap[iconString] ?? _defaultIconData;
  }

  static String iconDataToJson(IconData icon) {
    return _reverseIconMap[icon] ?? "";
  }
}

const Map<String, IconData> _iconMap = {
  'accessibility_new': Icons.accessibility_new_outlined,
  'person_outline': Icons.person_outline_outlined,
  'family_restroom': Icons.family_restroom_outlined,
  'payment': Icons.payment_outlined,
  'storefront': Icons.storefront_outlined,
  'work': Icons.work_outline,
  'account_balance_wallet': Icons.account_balance_wallet_outlined,
  'attach_money': Icons.attach_money_outlined,
  'savings': Icons.savings_outlined,
  'shopping_bag': Icons.shopping_bag_outlined,
  'add_shopping_cart': Icons.add_shopping_cart_outlined,
  'supervisor_account': Icons.supervisor_account_outlined,
  'swap_horiz': Icons.swap_horiz_outlined,
  'flight_takeoff': Icons.flight_takeoff_outlined,
  'sensors': Icons.sensors_outlined,
  'book': Icons.book_outlined,
  'shopping_basket': Icons.shopping_basket_outlined,
  'perm_phone_msg': Icons.perm_phone_msg_outlined,
  'build_circle': Icons.build_circle_outlined,
  'comment': Icons.comment_outlined,
  'construction': Icons.construction_outlined,
  'sentiment_very_satisfied': Icons.sentiment_very_satisfied_outlined,
  'handshake': Icons.handshake_outlined,
  'content_paste': Icons.content_paste_outlined,
  'receipt_long': Icons.receipt_long_outlined,
  'auto_stories': Icons.auto_stories_outlined
};
