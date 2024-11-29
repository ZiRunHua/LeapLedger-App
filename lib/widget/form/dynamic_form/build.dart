part of 'enter.dart';

abstract class FormDataModel {
  Map<String, dynamic> data = {};
  abstract final String name;

  List<FormFieldBase> _buildFileds(){
    var list = buildFileds();
    list.forEach((action) => action.value = data[action.key]);
    return list;
  }

  List<FormFieldBase> buildFileds();
  Future<Map<String, dynamic>> fetchData();
  Future<void> fetchAndSaveData() async => data = await fetchData();
  Future<bool> save();
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = {};
    data.forEach((key, value) {
      if (value is RangeValues) {
        jsonData[key] = {
          'Start': value.start,
          'End': value.end,
        };
      } else if (value is DateTimeRange) {
        jsonData[key] = {
          'Start': value.start.toUtc().toIso8601String(),
          'End': value.end.toUtc().toIso8601String(),
        };
      } else if (value is DateTime) {
        jsonData[key] = value.toUtc().toIso8601String();
      } else {
        jsonData[key] = value;
      }
    });
    print(jsonData);
    return jsonData;
  }

  Future<void> saveAndPop(BuildContext context) async {
    if (await save()) Navigator.pop(context);
  }
}

class AutoSaveDynamicForm extends StatefulWidget {
  final FormDataModel model;

  AutoSaveDynamicForm({Key? key, required this.model}) : super(key: key);

  @override
  State<AutoSaveDynamicForm> createState() => _AutoSaveDynamicFormState();
}

class _AutoSaveDynamicFormState extends State<AutoSaveDynamicForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(AutoSaveDynamicForm oldWidget) {
    _fetchData();
    super.didUpdateWidget(oldWidget);
  }

  _fetchData() async {
    if (widget.model.data.length > 0) return;
    await widget.model.fetchAndSaveData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.name)),
      body: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () {
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            widget.model.data = _formKey.currentState!.value;
            widget.model.save();
          }
        },
        child: SingleChildScrollView(
          child: widget.model.data.length > 0
              ? Padding(
                  padding: EdgeInsets.all(Constant.margin),
                  child: Column(
                    children: widget.model
                        ._buildFileds()
                        .map(
                          (field) => Padding(
                            padding: EdgeInsets.all(Constant.margin),
                            child: field.build(),
                          ),
                        )
                        .toList(),
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}

class ManualSaveDynamicForm extends StatefulWidget {
  final FormDataModel model;

  ManualSaveDynamicForm({Key? key, required this.model}) : super(key: key);

  @override
  State<ManualSaveDynamicForm> createState() => _ManualSaveDynamicFormState();
}

class _ManualSaveDynamicFormState extends State<ManualSaveDynamicForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(ManualSaveDynamicForm oldWidget) {
    _fetchData();
    super.didUpdateWidget(oldWidget);
  }

  _fetchData() async {
    if (widget.model.data.length > 0) return;
    await widget.model.fetchAndSaveData();
    setState(() {});
  }

  void _submit() {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
    widget.model.data = _formKey.currentState!.value;
    widget.model.save();
    Navigator.pop(context);
  }

  void _reset() {
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.model.name)),
      body: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: widget.model.data.length > 0
                  ? Padding(
                      padding: EdgeInsets.all(Constant.margin),
                      child: Column(
                        children: widget.model
                            ._buildFileds()
                            .map(
                              (field) => Padding(
                                padding: EdgeInsets.all(Constant.margin),
                                child: field.build(),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : SizedBox(),
            )),
            _buildButton()
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Material(
      elevation: Constant.elevation,
      child: Padding(
        padding: EdgeInsets.all(Constant.margin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FormButton.mediumElevatedBtn(context, "保存", _submit),
            FormButton.mediumElevatedBtn(context, "重置", _reset),
          ],
        ),
      ),
    );
  }
}
