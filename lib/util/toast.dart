part of 'enter.dart';

class Toast {
  static error({required String message}) {
    fluttertoast.Fluttertoast.showToast(
        msg: message,
        toastLength: fluttertoast.Toast.LENGTH_SHORT,
        gravity: fluttertoast.ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: ConstantFontSize.bodyLarge);
  }
}
