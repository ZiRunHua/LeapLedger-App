import 'package:fluttertoast/fluttertoast.dart';
import 'package:leap_ledger_app/common/global.dart';

tipToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      fontSize: ConstantFontSize.bodyLarge);
}
