part of 'enter.dart';

class AmountInput extends StatelessWidget {
  static const InputDecoration defaultDecoration = InputDecoration(
    contentPadding: EdgeInsets.all(Constant.padding),
    prefixText: "￥",
    labelStyle: TextStyle(fontSize: 14),
    border: OutlineInputBorder(),
    // You can further style the input here
  );
  final Function(int?) onSave;
  final InputDecoration decoration;
  final int? initialValue;
  const AmountInput({
    required this.onSave,
    this.initialValue,
    this.decoration = defaultDecoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 150,
      child: TextFormField(
        style: const TextStyle(fontSize: 14),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        initialValue: initialValue != null ? (initialValue! / 100).toStringAsFixed(2) : null,
        showCursor: true,
        maxLength: 10,
        maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
        buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
        decoration: decoration,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        onSaved: (String? value) {
          double? doubleResult = Data.stringToDouble(value);
          int? intResult = doubleResult != null ? (doubleResult * 100).toInt() : null;
          onSave(intResult);
        },
      ),
    );
  }
}
