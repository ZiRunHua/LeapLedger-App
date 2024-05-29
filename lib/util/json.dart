part of 'enter.dart';

class Json {
  static DateTime dateTimeFromJson(dynamic timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp != null ? timestamp * 1000 - Global.serverTimeDifference : 0);
  }

  static int dateTimeToJson(DateTime? dateTime) {
    return dateTime != null ? (dateTime.millisecondsSinceEpoch + Global.serverTimeDifference) ~/ 1000 : 0;
  }

  static DateTime? optionDateTimeFromJson(dynamic timestamp) {
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000 - Global.serverTimeDifference)
        : null;
  }

  static int? optionDateTimeToJson(DateTime? dateTime) {
    return dateTime != null ? (dateTime.millisecondsSinceEpoch + Global.serverTimeDifference) ~/ 1000 : null;
  }

  static const defaultIconData = Icons.payment_outlined;

  static final Map<IconData, String> _reverseIconMap =
      Map.fromEntries(_iconMap.entries.map((entry) => MapEntry(entry.value, entry.key)));
  static IconData iconDataFormJson(dynamic iconString) {
    if (iconString == null) {
      return defaultIconData;
    }
    return _iconMap[iconString] ?? defaultIconData;
  }

  static String iconDataToJson(IconData icon) {
    return _reverseIconMap[icon] ?? "";
  }

  static IconData? optionIconDataFormJson(dynamic iconString) {
    if (iconString == null) {
      return null;
    }
    return _iconMap[iconString];
  }

  static String? optionIconDataToJson(IconData? icon) {
    return icon == null ? null : _reverseIconMap[icon];
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
  'auto_stories': Icons.auto_stories_outlined,
  'restaurant': Icons.restaurant_outlined,
  'run_circle': Icons.run_circle_outlined,
  'home': Icons.home_outlined,
  'directions_bus': Icons.directions_bus_outlined,
  'casino': Icons.casino_outlined,
  'apartment': Icons.apartment_outlined,
  'local_hospital': Icons.local_hospital_outlined,
  'movie_outlined': Icons.movie_outlined,
  'home_outlined': Icons.home_outlined,
  'medical_information': Icons.medical_information_outlined,
  'luggage': Icons.luggage_outlined,
  'grid_view': Icons.grid_view_outlined,
};
