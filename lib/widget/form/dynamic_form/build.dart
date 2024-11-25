part of 'enter.dart';

abstract class FormDataModel {
  late Map<String, dynamic> data;
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

class DynamicForm extends StatelessWidget {
  final FormDataModel model;
  final _formKey = GlobalKey<FormBuilderState>();
  DynamicForm({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        Future.microtask(() {
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            model.data = _formKey.currentState!.value;
            model.save();
          } else {
            print('实时保存失败: 表单验证未通过');
          }
        });
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Constant.padding),
          child: Column(
            children: model.buildFileds().map((field) => field.build()).toList(),
          ),
        ),
      ),
    );
  }
}

class DynamicFormPage extends StatelessWidget {
  final FormDataModel model;
  DynamicFormPage({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DynamicForm(model: model),
    );
  }
}

extension RangeValuesToJson on RangeValues {
  Map<String, double> toJson() {
    return {
      'start': this.start,
      'end': this.end,
    };
  }
}
