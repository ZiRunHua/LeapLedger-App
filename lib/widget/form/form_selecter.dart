part of 'form.dart';

class FormSelecter {
  static Widget accountIcon(IconData initialValue, {void Function(IconData)? onChanged}) {
    return CommonIconSelecter(
        initialValue,
        const [
          Icons.accessibility_new_outlined,
          Icons.person_outline_outlined,
          Icons.family_restroom_outlined,
          Icons.payment_outlined,
          Icons.storefront_outlined,
          Icons.work_outline,
          Icons.account_balance_wallet_outlined,
          Icons.attach_money_outlined,
          Icons.savings_outlined,
        ],
        onChanged: onChanged);
  }

  static Widget transactionCategoryIcon(IconData initialValue, {void Function(IconData)? onChanged}) {
    return CommonIconSelecter(
        initialValue,
        const [
          Icons.shopping_bag_outlined,
          Icons.add_shopping_cart_outlined,
          Icons.supervisor_account_outlined,
          Icons.swap_horiz_outlined,
          Icons.flight_takeoff_outlined,
          Icons.sensors_outlined,
          Icons.book_outlined,
          Icons.shopping_basket_outlined,
          Icons.payment_outlined,
          Icons.accessibility_new_outlined,
          Icons.perm_phone_msg_outlined,
          Icons.build_circle_outlined,
          Icons.work_outline,
          Icons.comment_outlined,
          Icons.construction_outlined,
          Icons.sentiment_very_satisfied_outlined,
          Icons.handshake_outlined,
          Icons.content_paste_outlined,
          Icons.receipt_long_outlined,
          Icons.auto_stories_outlined,
          Icons.restaurant_outlined,
          Icons.directions_bus_outlined,
          Icons.apartment_outlined,
          Icons.run_circle_outlined,
          Icons.casino_outlined,
          Icons.local_hospital_outlined,
          Icons.movie_outlined,
          Icons.home_outlined,
          Icons.medical_information_outlined,
          Icons.luggage_outlined,
          Icons.grid_view_outlined,
        ],
        onChanged: onChanged);
  }
}
