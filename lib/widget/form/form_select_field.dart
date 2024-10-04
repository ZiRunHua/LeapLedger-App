part of 'form.dart';

class BaseFormSelectField extends StatelessWidget {
  const BaseFormSelectField({required this.label, required this.controller, required this.onTap, this.enabled = true});
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.margin, horizontal: Constant.padding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(Constant.margin),
            child: Text(label, style: TextStyle(letterSpacing: Constant.margin / 2)),
          ),
          Expanded(
            child: TextFormField(
              textAlign: TextAlign.right,
              textAlignVertical: TextAlignVertical.center,
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon:
                    enabled ? Icon(Icons.keyboard_arrow_right_rounded, color: ConstantColor.greyButtonIcon) : null,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: InputBorder.none,
              ),
              onTap: onTap,
              enabled: enabled,
            ),
          )
        ],
      ),
    );
  }
}

class FormSelectField<T extends Comparable> extends StatefulWidget {
  FormSelectField(
      {super.key,
      required this.label,
      required this.options,
      this.initialValue,
      required this.onTap,
      this.selectMode = SelectMode.bottomSheet,
      this.canEdit = true,
      this.buildSelecter});
  final String label;
  final List<SelectOption<T>> options;
  final T? initialValue;
  final void Function(T data) onTap;
  final SelectMode selectMode;
  final bool canEdit;
  final Widget Function({required List<SelectOption<T>> options, required void Function(SelectOption<T> value) onTap})?
      buildSelecter;
  @override
  _FormSelectFieldState<T> createState() => _FormSelectFieldState<T>();
}

class _FormSelectFieldState<T extends Comparable> extends State<FormSelectField<T>> {
  late SelectOption<T> selectedOption;

  late TextEditingController _controller;
  @override
  void initState() {
    assert(widget.options.isNotEmpty);
    if (widget.initialValue == null) {
      this.selectedOption = widget.options.first;
    } else {
      this.selectedOption = widget.options.firstWhere((element) => element.value == widget.initialValue);
    }
    _controller = TextEditingController(text: selectedOption.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseFormSelectField(
      label: widget.label,
      controller: _controller,
      onTap: _onTapInput,
      enabled: widget.canEdit,
    );
  }

  _onTapInput() {
    switch (widget.selectMode) {
      default:
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return widget.buildSelecter != null
                  ? widget.buildSelecter!(options: widget.options, onTap: _onSelcted)
                  : BottomSelecter<T>(options: widget.options, onTap: _onSelcted);
            });
    }
  }

  _onSelcted(SelectOption<T> value) {
    selectedOption = value;
    _controller.text = selectedOption.name;
    widget.onTap(value.value);
  }
}

class FromDateSelectField extends StatefulWidget {
  const FromDateSelectField(
      {super.key, this.initialValue, this.mode = DateSelectMode.day, required this.onTap, this.enabled = true});
  final DateSelectMode mode;
  final DateTime? initialValue;
  final void Function(DateTime data) onTap;
  final bool enabled;
  @override
  State<FromDateSelectField> createState() => FromDateSelectFieldState();
}

class FromDateSelectFieldState extends State<FromDateSelectField> {
  late TextEditingController _controller;
  late DateTime selectedDate;
  String get dataFormat => widget.mode.getDateFormat(selectedDate);

  @override
  void initState() {
    if (widget.initialValue == null) {
      selectedDate = DateTime.now();
    } else {
      selectedDate = widget.initialValue!;
    }
    _controller = TextEditingController(text: dataFormat);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FromDateSelectField oldWidget) {
    _controller.text = dataFormat;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BaseFormSelectField(
      label: "时间",
      controller: _controller,
      onTap: _onTap,
      enabled: widget.enabled,
    );
  }

  _onTap() async {}

  resetDate(DateTime value) {
    selectedDate = value;
    setState(() {});
  }
}

class CustomModalBottomSheetRoute extends PageRouteBuilder {
  final Widget page;
  CustomModalBottomSheetRoute(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset(0.0, 0.0);
            const curve = Curves.easeInOut;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          opaque: false,
          barrierColor: Colors.black54,
          barrierDismissible: true,
        );
}
