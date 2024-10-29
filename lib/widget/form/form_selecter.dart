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

class SelectOption<T extends Comparable> {
  final String name;
  final T value;
  SelectOption({required this.name, required this.value});
}

enum SelectMode { bottomSheet }

abstract class bottomSelecter<T extends Comparable> extends StatefulWidget {
  final T? selected;
  final List<SelectOption<T>> options;
  final ValueChanged<SelectOption<T>> onTap;
  final Color backgroundColor;
  final double? height;
  const bottomSelecter({
    super.key,
    this.selected,
    required this.options,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.height,
  });
}



enum DateSelectMode {
  day,
  week,
  month;

  String getDateFormat(DateTime date) {
    {
      switch (this) {
        case DateSelectMode.day:
          return DateFormat('yyyy-MM-dd').format(date);
        case DateSelectMode.week:
          return DateFormat('EEEE').format(date);
        case DateSelectMode.month:
          return DateFormat('dd日').format(date);
        default:
          return DateFormat('yyyy-MM-dd').format(date);
      }
    }
  }
}

class BottomSelecter<T extends Comparable> extends bottomSelecter<T> {
  const BottomSelecter(
      {super.key,
      required super.options,
      required super.onTap,
      super.selected,
      super.backgroundColor,
      super.height = null});

  @override
  State<BottomSelecter<T>> createState() => _BottomSelecterState<T>();
}

class _BottomSelecterState<T extends Comparable> extends State<BottomSelecter<T>> {
  T? selected;
  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomSelecter<T> oldWidget) {
    selected = widget.selected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // int selectedIndext = widget.options.indexWhere((element) => element.value == selected);
    // if (selectedIndext < 0) {
    //   widget.onTap(widget.options.first);
    //   selected = widget.options.first.value;
    // }
    Widget child;
    if (widget.options.length > 5) {
      child = ListView.builder(
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          return itemBuilder(context, widget.options[index]);
        },
      );
    } else {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widget.options.map((element) => itemBuilder(context, element)).toList(),
      );
    }
    child = Padding(
      padding: EdgeInsets.only(top: Constant.buttomSheetRadius, bottom: Constant.margin),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: ConstantDecoration.bottomSheetBorderRadius,
        ),
        child: child,
      ),
    );
    if (widget.height != null) {
      child = SizedBox(height: widget.height, child: child);
    } else if (widget.options.length > 5) {
      child = SizedBox(height: MediaQuery.of(context).size.height / 2, child: child);
    }
    return child;
  }

  Widget itemBuilder(BuildContext context, SelectOption<T> option) {
    return ListTile(
      selectedTileColor: ConstantColor.greyBackground,
      selectedColor: ConstantColor.primaryColor,
      selected: selected == option.value,
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(option.name, textAlign: TextAlign.center),
      onTap: () {
        selected = option.value;
        widget.onTap(option);
        setState(() {});
      },
    );
  }
}

class BottomCupertinoSelecter<T extends Comparable> extends bottomSelecter<T> {
  BottomCupertinoSelecter({
    super.key,
    required super.options,
    required super.onTap,
    super.selected,
    super.backgroundColor,
    double? height,
  }) : super(height: height ?? Constant.buttomHight);

  @override
  State<BottomCupertinoSelecter<T>> createState() => _BottomCupertinoSelecterState<T>();
}

class _BottomCupertinoSelecterState<T extends Comparable> extends State<BottomCupertinoSelecter<T>> {
  T? selected;
  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomCupertinoSelecter<T> oldWidget) {
    selected = widget.selected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndext = widget.options.indexWhere((element) => element.value == selected);
    if (selectedIndext < 0) {
      selectedIndext = 0;
      widget.onTap(widget.options.first);
      selected = widget.options.first.value;
    }
    return SizedBox(
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: ConstantDecoration.bottomSheetBorderRadius,
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.margin),
          child: CupertinoPicker(
            magnification: (2.35 / 2.1),
            squeeze: 1.25,
            scrollController: selected != null ? FixedExtentScrollController(initialItem: selectedIndext) : null,
            itemExtent: 32,
            onSelectedItemChanged: (int index) => widget.onTap(widget.options[index]),
            children: List<Widget>.generate(
                widget.options.length, (int index) => itemBuilder(context, widget.options[index])),
            looping: true,
          ),
        ),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, SelectOption<T> option) {
    if (widget.selected != null && widget.selected == option.value) {}
    return Padding(
      padding: EdgeInsets.only(left: Constant.padding),
      child: Text(option.name),
    );
  }
}

class FilterBottomSelecter extends StatefulWidget {
  const FilterBottomSelecter(
      {super.key,
      this.selected,
      required this.options,
      required this.onTap,
      required this.backgroundColor,
      this.listHeight});
  final String? selected;
  final List<SelectOption<String>> options;
  final ValueChanged<SelectOption<String>> onTap;
  final Color backgroundColor;
  final double? listHeight;
  @override
  State<FilterBottomSelecter> createState() => _FilterBottomSelecterState();
}

class _FilterBottomSelecterState extends State<FilterBottomSelecter> {
  String input = "";
  List<SelectOption<String>> get options => widget.options.where((value) => value.value.contains(input)).toList();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.padding),
          child: FormInputField.general<String>(
            onChanged: (String? input) {
              this.input = input ?? "";
              setState(() {});
            },
            decoration: const InputDecoration(
              icon: Icon(Icons.search_rounded),
              border: UnderlineInputBorder(),
              hoverColor: Colors.black,
            ),
          ),
        ),
        BottomSelecter(
          options: options,
          onTap: widget.onTap,
          selected: widget.selected,
          backgroundColor: widget.backgroundColor,
          height: widget.listHeight,
        ),
      ],
    );
  }
}
