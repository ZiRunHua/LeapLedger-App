part of 'enter.dart';

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
      text = "+ ";
    } else if (incomeExpense == IncomeExpense.expense) {
      text = "- ";
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
