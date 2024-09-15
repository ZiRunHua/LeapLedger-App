part of 'enter.dart';

class FromField extends StatefulWidget {
  const FromField({super.key});

  @override
  State<FromField> createState() => _FromFieldState();
}

class _FromFieldState extends State<FromField> {
  final TextEditingController _controller = TextEditingController();
  late final TransactionTimingCubit _cubit;

  @override
  void initState() {
    _cubit = BlocProvider.of<TransactionTimingCubit>(context);
    _controller.text = _cubit.config.toDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionTimingCubit, TransactionTimingState>(
      listener: (context, state) {
        if (state is TransactionTimingTypeChanged || state is TransactionTimingNextTimeChanged) {
          _controller.text = _cubit.config.toDisplay();
          setState(() {});
        }
      },
      child: BaseFormSelectField(
        label: "重复",
        controller: _controller,
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) => BlocProvider.value(value: _cubit, child: TimingBottomSelecter()),
        ),
      ),
    );
  }
}
