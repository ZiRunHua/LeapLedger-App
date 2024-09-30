part of 'enter.dart';

enum AmountKeyboardAction { add, backspace, subtract, complete, again }

class AmountKeyboard extends StatefulWidget {
  const AmountKeyboard({super.key, required this.onRefresh, required this.onComplete, this.openAgain = true});

  final Function(int amount, String input, String history) onRefresh;
  final Function(bool isAgain, int? amount) onComplete;
  final bool openAgain;
  @override
  State<AmountKeyboard> createState() => _AmountKeyboardState();
}

class _AmountKeyboardState extends State<AmountKeyboard> {
  late int amount;
  late String operator;
  late int input;
  late String inputString;
  late int baseNumber;
  late String history;
  @override
  void initState() {
    initValue();
    super.initState();
  }

  initValue() {
    history = "";
    amount = 0;
    input = 0;
    inputString = "";
    baseNumber = 100;
    operator = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constant.margin / 2, vertical: Constant.margin / 2),
      width: MediaQuery.sizeOf(context).width,
      color: ConstantColor.greyBackground,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(const Text("1"), () => onClickNumber(1)),
              _buildButton(const Text("4"), () => onClickNumber(4)),
              _buildButton(const Text("7"), () => onClickNumber(7)),
              _buildButton(const Text("."), () => onClickDot())
            ],
          )),
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(const Text("2"), () => onClickNumber(2)),
              _buildButton(const Text("5"), () => onClickNumber(5)),
              _buildButton(const Text("8"), () => onClickNumber(8)),
              _buildButton(const Text("0"), () => onClickNumber(0))
            ],
          )),
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(const Text("3"), () => onClickNumber(3)),
              _buildButton(const Text("6"), () => onClickNumber(6)),
              _buildButton(const Text("9"), () => onClickNumber(9)),
              _buildButton(
                const Text("再记"),
                () => widget.openAgain ? onClickAction(AmountKeyboardAction.again) : {},
                backgroundColor: widget.openAgain ? ConstantColor.secondaryColor : Colors.grey.shade200,
              )
            ],
          )),
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(const Icon(Icons.backspace_outlined), () => onClickAction(AmountKeyboardAction.backspace)),
              _buildButton(const Text("+"), () => onClickAction(AmountKeyboardAction.add)),
              _buildButton(const Text("-"), () => onClickAction(AmountKeyboardAction.subtract)),
              _buildButton(const Text("完成"), () => onClickAction(AmountKeyboardAction.complete),
                  backgroundColor: ConstantColor.primaryColor)
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildButton(Widget name, Function onTap, {Color backgroundColor = Colors.white}) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        margin: const EdgeInsets.all(Constant.margin / 2),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constant.radius), color: backgroundColor),
        child: Ink(
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constant.radius)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(Constant.radius),
                  onTap: () {
                    onTap();
                  },
                  child: Center(
                    child: name,
                  )),
            )),
      ),
    );
  }

  _transmitRefresh() {
    widget.onRefresh(amount, inputString, history);
  }

  refreshInputNumberString() {
    double number = input.abs() / 100;
    inputString = operator + number.toStringAsFixed(number % 1 == 0 ? 0 : 2);
  }

  onClickNumber(int number) {
    if (baseNumber == 0) {
      return;
    }
    amount -= input;
    if (baseNumber.abs() == 100) {
      // 处理整数部分
      int newNumber = input * 10 + number * baseNumber;
      if (checkAmount(newNumber)) {
        input = newNumber;
      }
      refreshInputNumberString();
    } else {
      // 处理小数部分
      if (number != 0) {
        input += number * baseNumber;
        refreshInputNumberString();
      } else {
        inputString += "0";
      }
      baseNumber ~/= 10;
    }
    amount += input;
    _transmitRefresh();
  }

  bool checkAmount(int amount) {
    return Constant.maxAmount >= amount;
  }

  onClickDot() {
    if (input == 0) {
      inputString = "${operator}0.";
    } else {
      inputString += ".";
    }
    baseNumber ~/= 10;
    _transmitRefresh();
  }

  onClickAction(AmountKeyboardAction type) {
    switch (type) {
      case AmountKeyboardAction.add:
        baseNumber = baseNumber.abs();
        handleNumberAfterClickOperator();
        inputString = "+";
        baseNumber = 100;
        operator = "+";
        _transmitRefresh();
      case AmountKeyboardAction.subtract:
        baseNumber = -baseNumber.abs();
        handleNumberAfterClickOperator();
        inputString = "-";
        baseNumber = -100;
        operator = "-";
        _transmitRefresh();
      case AmountKeyboardAction.backspace:
        if (inputString.isEmpty) {
          return;
        }
        if (input == 0) {
          inputString = inputString.substring(0, inputString.length - 1);
          _transmitRefresh();
          return;
        }
        amount -= input;
        switch (baseNumber.abs()) {
          case 100:
            input ~/= 10;
            input -= input % 100;
            refreshInputNumberString();
          case 10:
            inputString = inputString.substring(0, inputString.length - 1);
            baseNumber = 100;
          case 1:
            input -= input % 100;
            baseNumber = 10;
            inputString = inputString.substring(0, inputString.length - 1);
          case 0:
            input -= input % 10;
            baseNumber = 1;
            inputString = inputString.substring(0, inputString.length - 1);
        }
        amount += input;
        _transmitRefresh();
      case AmountKeyboardAction.complete:
        if (inputString == "") {
          widget.onComplete(false, null);
        } else {
          widget.onComplete(false, amount);
        }
      case AmountKeyboardAction.again:
        if (inputString == "") {
          widget.onComplete(true, null);
        } else {
          widget.onComplete(true, amount);
        }
        initValue();
        _transmitRefresh();

      default:
        return;
    }
  }

  handleNumberAfterClickOperator() {
    if (input == 0) {
      return;
    }
    history += inputString;
    inputString = "";
    input = 0;
    operator = "";
  }
}

class TextAmountKeyboard extends StatefulWidget {
  const TextAmountKeyboard({super.key});

  @override
  State<TextAmountKeyboard> createState() => _TextAmountKeyboardState();
}

class _TextAmountKeyboardState extends State<TextAmountKeyboard> {
  int amount = 0;
  String history = "", input = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(Constant.margin),
          margin: const EdgeInsets.all(Constant.margin),
          alignment: Alignment.centerRight,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            AmountText.sameHeight(
              amount,
              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
              dollarSign: true,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      history,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontSize: ConstantFontSize.bodySmall),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      input,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: ConstantFontSize.headline),
                    )
                  ],
                ))
          ]),
        ),
        AmountKeyboard(
          onRefresh: updateAmount,
          onComplete: onComplete,
        )
      ],
    );
  }

  updateAmount(int amount, String input, String history) {
    setState(() {
      this.amount = amount;
      this.input = input;
      this.history = history;
    });
  }

  onComplete(bool isAgain, int? amount) {}
}
