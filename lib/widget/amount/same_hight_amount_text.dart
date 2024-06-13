part of 'enter.dart';

/// 弃用 改用 [AmountTextSpan.sameHeight]
@Deprecated("use AmountTextSpan")
class SameHightAmountTextSpan extends StatelessWidget {
  final int amount;
  late final TextStyle _textStyle;
  final bool dollarSign;
  final IncomeExpense? incomeExpense;
  final IncomeExpenseDisplayModel? displayModel;
  late final String prefix;
  SameHightAmountTextSpan(
      {super.key,
      required this.amount,
      TextStyle textStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      this.dollarSign = false,
      this.incomeExpense,
      this.displayModel}) {
    if (displayModel == IncomeExpenseDisplayModel.color) {
      prefix = "";
      if (incomeExpense == IncomeExpense.income) {
        _textStyle = textStyle.copyWith(color: ConstantColor.incomeAmount);
      } else if (incomeExpense == IncomeExpense.expense) {
        _textStyle = textStyle.copyWith(color: ConstantColor.expenseAmount);
      } else {
        _textStyle = textStyle;
      }
    } else if (displayModel == IncomeExpenseDisplayModel.symbols) {
      _textStyle = textStyle;
      if (incomeExpense == IncomeExpense.income) {
        prefix = "+";
      } else if (incomeExpense == IncomeExpense.expense) {
        prefix = "-";
      } else {
        prefix = "";
      }
    } else {
      _textStyle = textStyle;
      prefix = "";
    }
  }

  @override
  Text build(BuildContext context) {
    double amountInDollars = amount / 100.0;
    String formattedAmount = amountInDollars.toStringAsFixed(2);
    List<String> parts = formattedAmount.split('.');
    return Text.rich(
      TextSpan(
        text: prefix + (dollarSign ? '￥${parts[0]}' : parts[0]),
        style: _textStyle,
        children: [
          TextSpan(
            text: '.${parts[1]}',
            style: _textStyle,
          )
        ],
      ),
    );
  }
}

enum IncomeExpenseDisplayModel { color, symbols }

class AmountTextSpan extends TextSpan {
  const AmountTextSpan({
    String? text,
    List<TextSpan>? children,
    TextStyle? style,
    MouseCursor? mouseCursor,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    String? semanticsLabel,
    Locale? locale,
    bool? spellOut,
  }) : super(
          text: text,
          children: children,
          style: style,
          mouseCursor: mouseCursor,
          onEnter: onEnter,
          onExit: onExit,
          semanticsLabel: semanticsLabel,
          locale: locale,
          spellOut: spellOut,
        );

  factory AmountTextSpan.sameHeight(int amount,
      {TextStyle? textStyle,
      bool dollarSign = false,
      bool unit = false,
      IncomeExpense? incomeExpense,
      IncomeExpenseDisplayModel? displayModel}) {
    late String text;
    (text, textStyle) = _getTextAndStyle(amount,
        textStyle: textStyle,
        dollarSign: dollarSign,
        unit: unit,
        incomeExpense: incomeExpense,
        displayModel: displayModel);

    return AmountTextSpan(text: text, style: textStyle);
  }
}

class AmountAutoSizeText extends AutoSizeText {
  const AmountAutoSizeText({
    required String text,
    List<TextSpan>? children,
    TextStyle? style,
    MouseCursor? mouseCursor,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    String? semanticsLabel,
    Locale? locale,
    bool? spellOut,
    List<double>? presetFontSizes,
    double? minFontSize,
    double? maxFontSize,
  }) : super(
          text,
          style: style,
          presetFontSizes: presetFontSizes,
          maxLines: 1,
        );

  factory AmountAutoSizeText.sameHeight(
    int amount, {
    TextStyle? textStyle,
    bool dollarSign = false,
    bool unit = false,
    IncomeExpense? incomeExpense,
    IncomeExpenseDisplayModel? displayModel,
    List<double>? presetFontSizes,
  }) {
    late String text;
    (text, textStyle) = _getTextAndStyle(amount,
        textStyle: textStyle,
        dollarSign: dollarSign,
        unit: unit,
        incomeExpense: incomeExpense,
        displayModel: displayModel);

    return AmountAutoSizeText(
      text: text,
      style: textStyle,
      presetFontSizes: presetFontSizes,
    );
  }
}

(String, TextStyle?) _getTextAndStyle(int amount,
    {TextStyle? textStyle,
    bool dollarSign = false,
    bool unit = false,
    IncomeExpense? incomeExpense,
    IncomeExpenseDisplayModel? displayModel}) {
  String text = '';
  if (displayModel == IncomeExpenseDisplayModel.color) {
    text = "";
    if (incomeExpense == IncomeExpense.income) {
      textStyle = textStyle != null
          ? textStyle.merge(const TextStyle(color: ConstantColor.incomeAmount))
          : const TextStyle(color: ConstantColor.incomeAmount);
    } else if (incomeExpense == IncomeExpense.expense) {
      textStyle = textStyle != null
          ? textStyle.merge(const TextStyle(color: ConstantColor.expenseAmount))
          : const TextStyle(color: ConstantColor.expenseAmount);
    }
  } else if (displayModel == IncomeExpenseDisplayModel.symbols) {
    if (incomeExpense == IncomeExpense.income) {
      text = "+";
    } else if (incomeExpense == IncomeExpense.expense) {
      text = "-";
    }
  }
  text += (dollarSign ? '￥${(amount / 100).toStringAsFixed(2)}' : (amount / 100).toStringAsFixed(2));
  if (unit) {
    text += '元';
  }
  return (text, textStyle);
}

class AmountText extends Text {
  const AmountText(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  });

  factory AmountText.sameHeight(int amount,
      {TextStyle? textStyle,
      bool dollarSign = false,
      bool unit = false,
      IncomeExpense? incomeExpense,
      IncomeExpenseDisplayModel? displayModel}) {
    late String text;
    (text, textStyle) = _getTextAndStyle(amount,
        textStyle: textStyle,
        dollarSign: dollarSign,
        unit: unit,
        incomeExpense: incomeExpense,
        displayModel: displayModel);

    return AmountText(text, style: textStyle);
  }
}
