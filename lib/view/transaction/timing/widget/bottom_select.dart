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
    _cubit = BlocProvider.of<TransactionTimingCubit>(context);
    super.initState();
  }

  final double _leftWidth = 160;
  final double _height = 320;
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
                  firstDate: Constant.minDateTime,
                  lastDate: Constant.maxDateTime,
                );
                if (dateTime == null) {
                  return;
                }
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
    return Row(children: [
      AnimatedContainer(
        duration: _animatedDuration,
        width: _isBuildTimeSelecter ? _leftWidth : MediaQuery.of(context).size.width,
        child: BottomSelecter(
          options: TransactionTimingType.selectOptions,
          backgroundColor: Colors.transparent,
          selected: _config.type,
          height: _height.h,
          onTap: onTapType,
        ),
      ),
      AnimatedContainer(
        duration: _animatedDuration,
        width: _config.type == TransactionTimingType.everyWeek ? MediaQuery.of(context).size.width - _leftWidth : 0,
        child: createBottomSelect(
            backgroundColor: ConstantColor.greyBackground,
            onTap: onDateTimeChanged,
            selected: _config.nextTime,
            mode: DateSelectMode.week,
            type: BottomCupertinoSelecter,
            height: _height.h),
      ),
      AnimatedContainer(
        duration: _animatedDuration,
        width: _config.type == TransactionTimingType.everyMonth ? MediaQuery.of(context).size.width - _leftWidth : 0,
        child: createBottomSelect(
            backgroundColor: ConstantColor.greyBackground,
            onTap: onDateTimeChanged,
            selected: _config.nextTime,
            mode: DateSelectMode.month,
            type: BottomCupertinoSelecter,
            height: _height.h),
      )
    ]);
  }

  onTapType(SelectOption<TransactionTimingType> selected) {
    _cubit.changeTimingType(selected.value);
  }

  onDateTimeChanged(SelectOption<DateTime> selectDate) {
    _cubit.changeNextTime(selectDate.value);
  }
}
