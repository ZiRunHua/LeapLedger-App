part of 'enter.dart';

class TimingBottomSelecter extends StatefulWidget {
  const TimingBottomSelecter({super.key});
  @override
  State<TimingBottomSelecter> createState() => _TimingBottomSelecterState();
}

class _TimingBottomSelecterState extends State<TimingBottomSelecter> {
  late final TransactionTimingCubit _cubit;
  TransactionTimingModel get _config => _cubit.config;
  bool get _isBuildTimeSelecter =>
      _config.type == TransactionTimingType.everyMonth || _config.type == TransactionTimingType.everyWeek;
  @override
  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<TransactionTimingCubit>(context);
  }

  final double _leftWidth = 160.w;
  final double _height = 300.sp;
  final Duration _animatedDuration = Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionTimingCubit, TransactionTimingState>(
        listener: (context, state) async {
          if (state is TransactionTimingConfigSaved) {
            Navigator.pop(context);
          } else if (state is TransactionTimingTypeChanged) {
            switch (_config.type) {
              case TransactionTimingType.once:
                final DateTime? dateTime = await showDatePicker(
                  context: context,
                  initialDate: _config.nextTime,
                  firstDate: _cubit.nowTime.add(const Duration(days: 1)),
                  lastDate: Constant.maxDateTime,
                );
                if (dateTime == null) {
                  return;
                }
                _cubit.changeNextTime(dateTime);
              default:
                return;
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<TransactionTimingCubit, TransactionTimingState>(
              buildWhen: (previous, current) => current is TransactionTimingTypeChanged,
              builder: (context, state) {
                return _buildContent();
              },
            ),
            SaveButtom()
          ],
        ));
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: _animatedDuration,
          width: _isBuildTimeSelecter ? _leftWidth : MediaQuery.of(context).size.width,
          child: BottomSelecter(
            options: TransactionTimingType.selectOptions,
            backgroundColor: Colors.transparent,
            selected: _config.type,
            height: _height,
            onTap: onTapType,
          ),
        ),
        AnimatedContainer(
          duration: _animatedDuration,
          width: _config.type == TransactionTimingType.everyWeek ? MediaQuery.of(context).size.width - _leftWidth : 0,
          child: createBottomSelect(
            backgroundColor: ConstantColor.greyBackground,
            onTap: (SelectOption<int> selectDate) {
              if (_config.type != TransactionTimingType.everyWeek) return;
              onDateTimeChanged(selectDate);
            },
            selected: _config.nextTime.weekday,
            mode: DateSelectMode.week,
            type: BottomCupertinoSelecter,
            height: _height,
          ),
        ),
        AnimatedContainer(
          duration: _animatedDuration,
          width: _config.type == TransactionTimingType.everyMonth ? MediaQuery.of(context).size.width - _leftWidth : 0,
          child: createBottomSelect(
            backgroundColor: ConstantColor.greyBackground,
            onTap: (SelectOption<int> selectDate) {
              if (_config.type != TransactionTimingType.everyMonth) return;
              onDateTimeChanged(selectDate);
            },
            selected: _config.nextTime.day,
            mode: DateSelectMode.month,
            type: BottomCupertinoSelecter,
            height: _height,
          ),
        )
      ],
    );
  }

  void onTapType(SelectOption<TransactionTimingType> selected) {
    _cubit.changeTimingType(selected.value);
  }

  onDateTimeChanged(SelectOption<int> selectDate) {
    _cubit.onOffsetDaysChanged(selectDate.value);
  }

  bottomSelecter createBottomSelect({
    int? selected,
    required ValueChanged<SelectOption<int>> onTap,
    required DateSelectMode mode,
    required Type type,
    required Color backgroundColor,
    double? height,
  }) {
    assert(mode == DateSelectMode.week || mode == DateSelectMode.month);
    List<SelectOption<int>> options = [];
    if (mode == DateSelectMode.month) {
      selected = selected ?? 1;
      var date = Tz.getFirstSecondOfDay(date: _cubit.nowTime).add(Duration(days: selected - 1));
      // The month has 28 days
      for (var i = selected; i <= 28; i++) {
        date = date.add(Duration(days: 1));
        options.add(SelectOption<int>(name: DateFormat.d().format(date), value: date.day));
      }
      date.add(Duration(days: 1 - date.day));
      for (var i = 1; i < selected; i++) {
        date = date.add(Duration(days: 1));
        options.add(SelectOption<int>(name: DateFormat.d().format(date), value: date.day));
      }
    } else {
      selected = selected ?? 1;
      var date = DateTime.now();
      date = date.add(Duration(days: selected - date.weekday));
      for (var i = 0; i < 7; i++) {
        date = date.add(Duration(days: 1));
        options.add(SelectOption<int>(name: DateFormat.E().format(date), value: date.weekday));
      }
    }
    switch (type) {
      case BottomSelecter:
        return BottomSelecter<int>(
            options: options, onTap: onTap, selected: selected, backgroundColor: backgroundColor, height: height);
      case BottomCupertinoSelecter:
        return BottomCupertinoSelecter<int>(
            options: options, onTap: onTap, selected: selected, backgroundColor: backgroundColor, height: height);
      default:
        return BottomSelecter<int>(
            options: options, onTap: onTap, selected: selected, backgroundColor: backgroundColor, height: height);
    }
  }
}
