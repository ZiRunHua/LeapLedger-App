part of 'enter.dart';

class ExampleFormDataModel extends FormDataModel {
  @override
  final String name = "动态表单示例";
  @override
  Future<Map<String, dynamic>> fetchData() {
    return Future.value(<String, dynamic>{
      'Name': '李华',
      'AcceptTerms': true,
      'Hobbies': ['read'],
      'Gender': 'Female',
      'VacationDates': DateTimeRange(
        start: DateTime(2024, 1, 1),
        end: DateTime(2024, 1, 7),
      ),
      'Appointment': DateTime(2024, 2, 20, 14, 0),
      'Country': 'CN',
      'Skills': ['Golang'],
      'PaymentMethod': 'AliPay',
      'PriceRange': RangeValues(200, 800),
      'Rating': 4.0,
      'Newsletter': true,
    });
  }

  Future<bool> save() {
    print(JsonEncoder.withIndent('  ').convert(toJson()));
    return Future.value(true);
  }

  List<FormFieldBase> buildFileds() {
    return <FormFieldBase>[
      TextFieldForm(
        key: 'Name',
        label: '姓名',
        required: true,
        hint: '请输入姓名',
      ),
      CheckboxForm(
        key: 'AcceptTerms',
        label: '接受条款和条件',
        required: true,
      ),
      CheckboxGroupForm<String>(
        key: 'Hobbies',
        label: '爱好',
        required: true,
        options: [
          SelectOption(name: "阅读", value: "read"),
          SelectOption(name: "旅行", value: "travel"),
          SelectOption(name: "运动", value: "exercise"),
        ],
      ),
      ChoiceChipForm<String>(
        key: 'Gender',
        label: '性别',
        required: true,
        options: [
          SelectOption(name: "男", value: "Male"),
          SelectOption(name: "女", value: "Female"),
          SelectOption(name: "其他", value: "Other"),
        ],
      ),
      DateRangePickerForm(
        key: 'VacationDates',
        label: '假期日期',
        required: true,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime(2030, 12, 31),
      ),
      DateTimePickerForm(
        key: 'Appointment',
        label: '预约时间',
        required: true,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime(2030, 12, 31),
      ),
      DropdownForm<String>(
        key: 'Country',
        label: '国家',
        required: true,
        items: [
          SelectOption(value: 'CN', name: '中国'),
          SelectOption(value: 'US', name: '美国'),
          SelectOption(value: 'CA', name: '加拿大'),
        ],
      ),
      FilterChipForm<String>(
        key: 'Skills',
        label: '技能',
        required: false,
        options: [
          SelectOption(value: 'Flutter', name: 'Flutter'),
          SelectOption(value: 'Golang', name: 'Golang'),
        ],
      ),
      RadioGroupForm<String>(key: 'PaymentMethod', label: '首选付款方式', required: true, options: [
        SelectOption(value: 'AliPay', name: '支付宝'),
        SelectOption(value: 'WeChatPay', name: '微信支付'),
      ]),
      RangeSliderForm(
        key: 'PriceRange',
        label: '价格范围',
        min: 0,
        max: 1000,
        divisions: 10,
      ),
      SliderForm(
        key: 'Rating',
        label: '评分',
        min: 0,
        max: 5,
        divisions: 5,
      ),
      SwitchForm(
        key: 'Newsletter',
        label: '订阅通讯',
      ),
    ];
  }
}

class ExampleDynamicForm extends StatefulWidget {
  final FormDataModel model;
  ExampleDynamicForm({Key? key, required this.model}) : super(key: key);

  @override
  State<ExampleDynamicForm> createState() => _ExampleDynamicFormState();
}

class _ExampleDynamicFormState extends State<ExampleDynamicForm> {
  @override
  Widget build(BuildContext context) {
    return ManualSaveDynamicForm(model: widget.model);
  }
}
