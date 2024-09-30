part of 'enter.dart';

enum Mode {
  normal,
  month,
  dateRange,
}

/// return中start是选中日期的第一秒 end是选中日期的最后一秒
Future<DateTimeRange?> showMonthOrDateRangePickerModalBottomSheet({
  required BuildContext context,
  required DateTimeRange initialValue,
  Mode mode = Mode.normal,
}) async {
  return await showModalBottomSheet<DateTimeRange>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) => MonthOrDateRangePicker(
      initialValue: initialValue,
      mode: mode,
    ),
  );
}

class MonthOrDateRangePicker extends StatefulWidget {
  const MonthOrDateRangePicker({required this.initialValue, super.key, required this.mode});
  final DateTimeRange initialValue;
  final Mode mode;
  @override
  // ignore: library_private_types_in_public_api
  _MonthOrDateRangePickerState createState() => _MonthOrDateRangePickerState();
}

class _MonthOrDateRangePickerState extends State<MonthOrDateRangePicker> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    startDate = widget.initialValue.start;
    endDate = widget.initialValue.end;
    if (widget.mode == Mode.normal) {
      //判断是否是使用月份选择 依据起始和结束时间是否是第一秒和最后一秒
      bool isFirstSecondOfMonth = startDate.isAtSameMomentAs(Time.getFirstSecondOfMonth(date: startDate));
      bool isLastSecondOfMonth = endDate.isAtSameMomentAs(Time.getLastSecondOfMonth(date: startDate));
      if (isFirstSecondOfMonth && isLastSecondOfMonth) {
        _tabController.index = _monthTabIndex;
      } else {
        _tabController.index = _dateRangeTabIndex;
      }
    }

    startDate = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    endDate = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    selectedMonth = DateTime(startDate.year, startDate.month, 1, 0, 0, 0);
  }

  late TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final int _monthTabIndex = 0, _dateRangeTabIndex = 1;
  late DateTime startDate, endDate, selectedMonth;
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    late Widget child, title;
    switch (widget.mode) {
      case Mode.month:
        child = _buildMonthPicker();
        title = const Padding(
          padding: EdgeInsets.fromLTRB(Constant.padding, Constant.padding, Constant.padding, 0),
          child: Text(
            '月份选择',
            style: TextStyle(
              fontSize: ConstantFontSize.headline,
              fontWeight: FontWeight.w500,
              letterSpacing: Constant.margin / 2,
            ),
          ),
        );
        break;
      case Mode.dateRange:
        child = _buildDateRangePicker();
        title = const Padding(
          padding: EdgeInsets.fromLTRB(Constant.padding, Constant.padding, Constant.padding, 0),
          child: Text(
            '日期选择',
            style: TextStyle(
              fontSize: ConstantFontSize.headline,
              fontWeight: FontWeight.w500,
              letterSpacing: Constant.margin / 2,
            ),
          ),
        );
      default:
        child = [_buildMonthPicker(), _buildDateRangePicker()][_tabController.index];
        title = TabBar(
          controller: _tabController,
          tabs: const [Tab(text: '月份选择'), Tab(text: '自定义时间')],
        );
        break;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        title,
        Container(
          padding: const EdgeInsets.all(Constant.padding),
          child: child,
        )
      ],
    );
  }

  /// 月份滚轮选择
  Widget _buildMonthPicker() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.monthYear,
              initialDateTime: selectedMonth,
              onDateTimeChanged: (DateTime newDate) {
                selectedMonth = newDate;
              },
            )),
        _buildSumbitButton(),
      ],
    );
  }

  bool selectedStartInputButton = true;
  UniqueKey startDatePickerKey = UniqueKey();
  UniqueKey endDatePickerKey = UniqueKey();

  /// 自定义时间（日期范围选择）
  Widget _buildDateRangePicker() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Constant.margin),
          child: _buildButtonGroup(),
        ),
        const SizedBox(height: 20),
        // 时间输入框
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 5, child: _buildInputButton(isStartInputButton: true)),
            const Expanded(
              child: Padding(padding: EdgeInsets.all(Constant.margin), child: Divider(color: Colors.black87)),
            ),
            Expanded(flex: 5, child: _buildInputButton(isStartInputButton: false)),
          ],
        ),
        // 日期滚轮
        SizedBox(
          height: 300,
          child: CupertinoDatePicker(
            key: selectedStartInputButton ? startDatePickerKey : endDatePickerKey,
            mode: CupertinoDatePickerMode.date,
            initialDateTime: selectedStartInputButton
                ? (startDate.year >= Constant.minYear ? startDate : Constant.minDateTime)
                : (endDate.year <= Constant.maxYear ? endDate : Constant.maxDateTime),
            minimumYear: Constant.minYear,
            maximumYear: Constant.maxYear,
            onDateTimeChanged: (DateTime newDate) {
              if (selectedStartInputButton) {
                startDate = newDate;
                if (minStartDate.isAfter(startDate))
                  endDate = maxEndDate;
                else if (startDate.isAfter(endDate)) endDate = startDate.copyWith();
              } else {
                endDate = newDate;
                if (endDate.isAfter(maxEndDate))
                  startDate = minStartDate;
                else if (startDate.isAfter(endDate)) startDate = endDate.copyWith();
              }
              setState(() {});
            },
          ),
        ),
        _buildSumbitButton()
      ],
    );
  }

  DateTime get minStartDate =>
      DateTime(endDate.year - Constantlimit.maxTimeRangeForYear, endDate.month, endDate.day, 0, 0, 0);
  DateTime get maxEndDate =>
      DateTime(startDate.year + Constantlimit.maxTimeRangeForYear, startDate.month, startDate.day, 23, 59, 59);

  /// 按钮组
  Widget _buildButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildMonthShortcutButton(numberOfMonths: 3, name: '近三月'),
            _buildMonthShortcutButton(numberOfMonths: 6, name: '近六月'),
            _buildMonthShortcutButton(numberOfMonths: 12, name: '近一年'),
          ],
        ),
        Row(
          children: [
            _buildShortcutButton(
              startDate: Time.getFirstSecondOfYear(numberOfYears: -1),
              endDate: Time.getLastSecondOfYear(numberOfYears: -1),
              name: '去年',
            ),
            _buildShortcutButton(
              startDate: Time.getFirstSecondOfYear(),
              endDate: Time.getLastSecondOfYear(),
              name: '今年',
            ),
          ],
        )
      ],
    );
  }

  void _initDateRangeButtonState({required DateTime startDate, required DateTime endDate}) {
    selectedStartInputButton = true;
    if (false == this.startDate.isAtSameMomentAs(startDate)) {
      startDatePickerKey = UniqueKey();
    }
    if (false == this.endDate.isAtSameMomentAs(endDate)) {
      endDatePickerKey = UniqueKey();
    }
    this.startDate = startDate;
    this.endDate = endDate;
  }

  /// 月份快捷按钮
  Widget _buildMonthShortcutButton({required int numberOfMonths, required String name}) {
    assert(numberOfMonths >= 1);
    return _buildShortcutButton(
      name: name,
      startDate: Time.getFirstSecondOfPreviousMonths(date: DateTime.now(), numberOfMonths: numberOfMonths - 1),
      endDate: Time.getLastSecondOfMonth(),
    );
  }

  /// 快捷按钮
  Widget _buildShortcutButton({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    var isSelected = this.startDate.isAtSameMomentAs(startDate) && this.endDate.isAtSameMomentAs(endDate);
    return GestureDetector(
      onTap: () {
        _initDateRangeButtonState(startDate: startDate, endDate: endDate);
        onSubmit();
      },
      child: Container(
        height: 28,
        margin: const EdgeInsets.all(Constant.margin / 2),
        padding: const EdgeInsets.symmetric(horizontal: Constant.margin),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? ConstantColor.primaryColor : Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: ConstantFontSize.bodySmall,
              color: isSelected ? ConstantColor.primaryColor : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  /// 输入框按钮
  Widget _buildInputButton({bool isStartInputButton = false}) {
    return GestureDetector(
      onTap: () => setState(() {
        selectedStartInputButton = isStartInputButton;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Constant.padding),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedStartInputButton == isStartInputButton ? ConstantColor.primaryColor : Colors.grey,
              width: 2.0,
            ),
          ),
        ),
        child: Center(
          child: Text(
            isStartInputButton ? DateFormat('yyyy-MM-dd').format(startDate) : DateFormat('yyyy-MM-dd').format(endDate),
            style: TextStyle(
              fontSize: 18,
              color: selectedStartInputButton == isStartInputButton ? ConstantColor.primaryColor : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  /// 提交按钮
  Widget _buildSumbitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onSubmit, child: const Text('确定')),
    );
  }

  onSubmit() {
    DateTime start, end;
    if (_tabController.index == _monthTabIndex) {
      start = DateTime(selectedMonth.year, selectedMonth.month, 1, 0, 0, 0);
      end = Time.getLastSecondOfMonth(date: start);
    } else {
      start = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
      end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    }
    Navigator.of(context).pop(DateTimeRange(start: start, end: end));
  }
}
