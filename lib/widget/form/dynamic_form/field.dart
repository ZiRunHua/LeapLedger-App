part of 'enter.dart';

enum FiledType {
  text,
  RadioGroup,
  CheckboxGroup,
  ChoiceChip,
  DateRangePicker;
}

abstract class FormFieldBase<T> {
  final String key;
  final String label;
  final String type;
  final bool required;
  T? value;
  FormFieldBase({
    required this.key,
    required this.label,
    required this.type,
    this.required = false,
    this.value = null,
  });

  Widget build();
}

class TextFieldForm extends FormFieldBase<String?> {
  @override
  String? value;
  final String? hint;
  final List<Map<String, dynamic>>? validators;

  TextFieldForm({
    required String key,
    required String label,
    bool required = false,
    this.value,
    this.hint,
    this.validators,
  }) : super(key: key, label: label, type: 'text_field', required: required);

  @override
  Widget build() {
    return FormBuilderTextField(
      name: key,
      decoration: InputDecoration(labelText: label, hintText: hint),
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
    );
  }
}

class CheckboxForm extends FormFieldBase<bool?> {
  @override
  bool? value;

  CheckboxForm({
    required String key,
    required String label,
    bool required = false,
    this.value,
  }) : super(key: key, label: label, type: 'checkbox', required: required);

  @override
  FormBuilderCheckbox build() {
    return FormBuilderCheckbox(
      name: key,
      title: Text(label),
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
    );
  }
}

class CheckboxGroupForm<T extends Comparable> extends FormFieldBase<List<T>?> {
  final List<SelectOption<T>>? options;
  @override
  List<T>? value;

  CheckboxGroupForm({
    required String key,
    required String label,
    bool required = false,
    this.options,
    this.value,
  }) : super(key: key, label: label, type: 'checkbox_group', required: required);

  @override
  Widget build() {
    return FormBuilderCheckboxGroup<T>(
      name: key,
      decoration: InputDecoration(labelText: label),
      options:
          options?.map((option) => FormBuilderFieldOption<T>(value: option.value, child: Text(option.name))).toList() ??
              [],
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
      onChanged: (value) {},
    );
  }
}

class ChoiceChipForm<T extends Comparable> extends FormFieldBase<T?> {
  final List<SelectOption<T>>? options;
  final T? value;

  ChoiceChipForm({
    required String key,
    required String label,
    bool required = false,
    this.options,
    this.value,
  }) : super(key: key, label: label, type: 'choice_chip', required: required);

  @override
  Widget build() {
    return FormBuilderChoiceChip<T>(
      name: key,
      decoration: InputDecoration(labelText: label),
      options:
          options?.map((option) => FormBuilderChipOption<T>(value: option.value, child: Text(option.name))).toList() ??
              [],
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
    );
  }
}

class DateRangePickerForm extends FormFieldBase<DateTimeRange?> {
  @override
  DateTimeRange? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  DateRangePickerForm({
    required String key,
    required String label,
    bool required = false,
    this.value,
    this.firstDate,
    this.lastDate,
  }) : super(key: key, label: label, type: 'date_range_picker', required: required);

  @override
  Widget build() {
    return FormBuilderDateRangePicker(
      name: key,
      decoration: InputDecoration(labelText: label),
      initialValue: value,
      firstDate: firstDate ?? Constant.minDateTime,
      lastDate: lastDate ?? Constant.maxDateTime,
      validator: required == true ? FormBuilderValidators.required() : null,
    );
  }
}

class DateTimePickerForm extends FormFieldBase<DateTime?> {
  @override
  DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;

  DateTimePickerForm({
    required String key,
    required String label,
    bool required = false,
    this.value,
    this.firstDate,
    this.lastDate,
  }) : super(key: key, label: label, type: 'date_time_picker', required: required);

  @override
  Widget build() {
    return FormBuilderDateTimePicker(
      name: key,
      decoration: InputDecoration(labelText: label),
      initialValue: value,
      firstDate: firstDate ?? Constant.minDateTime,
      lastDate: lastDate ?? Constant.maxDateTime,
      validator: required == true ? FormBuilderValidators.required() : null,
    );
  }
}

class DropdownForm<T extends Comparable> extends FormFieldBase<T?> {
  final List<SelectOption<T>> items;
  final T? initialValue;

  DropdownForm({
    required String key,
    required String label,
    bool required = false,
    required this.items,
    this.initialValue,
  }) : super(key: key, label: label, type: 'dropdown', required: required);

  @override
  Widget build() {
    return FormBuilderDropdown<T>(
      name: key,
      decoration: InputDecoration(labelText: label),
      initialValue: initialValue,
      items: items.map((item) => DropdownMenuItem<T>(value: item.value, child: Text(item.name))).toList(),
      validator: required == true ? FormBuilderValidators.required() : null,
    );
  }
}

class FilterChipForm<T extends Comparable> extends FormFieldBase<List<T>?> {
  @override
  List<T>? value;
  final List<SelectOption<T>> options;

  FilterChipForm({
    required String key,
    required String label,
    bool required = false,
    required this.options,
    this.value,
  }) : super(key: key, label: label, type: 'filter_chip', required: required);

  @override
  Widget build() {
    return FormBuilderFilterChip<T>(
      name: key,
      decoration: InputDecoration(labelText: label),
      options: options.map((item) => FormBuilderChipOption<T>(value: item.value, child: Text(item.name))).toList(),
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
    );
  }
}

class RadioGroupForm<T extends Comparable> extends FormFieldBase<T?> {
  @override
  T? value;
  final List<SelectOption<T>> options;

  RadioGroupForm({
    required String key,
    required String label,
    bool required = false,
    this.value,
    required this.options,
  }) : super(key: key, label: label, type: 'radio_group', required: required);

  @override
  Widget build() {
    return FormBuilderRadioGroup(
      name: key,
      decoration: InputDecoration(labelText: label),
      options: options.map((option) {
        return FormBuilderFieldOption(value: option.value, child: Text(option.name));
      }).toList(),
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
    );
  }
}

class RangeSliderForm extends FormFieldBase<RangeValues?> {
  @override
  RangeValues? value;
  final double min;
  final double max;
  final double divisions;

  RangeSliderForm({
    required String key,
    required String label,
    this.value,
    required this.min,
    required this.max,
    this.divisions = 1,
  }) : super(key: key, label: label, type: 'range_slider');

  @override
  Widget build() {
    return FormBuilderRangeSlider(
      name: key,
      decoration: InputDecoration(labelText: label),
      min: min,
      max: max,
      initialValue: value,
      divisions: divisions.toInt(),
    );
  }
}

class SliderForm extends FormFieldBase<double> {
  @override
  double? value;
  final double min;
  final double max;
  final int divisions;

  SliderForm({
    required String key,
    required String label,
    this.value,
    required this.min,
    required this.max,
    this.divisions = 1,
  }) : super(key: key, label: label, type: 'slider');

  @override
  Widget build() {
    return FormBuilderSlider(
      name: key,
      decoration: InputDecoration(labelText: label),
      min: min,
      max: max,
      initialValue: value ?? 0,
      divisions: divisions,
    );
  }
}

class SwitchForm extends FormFieldBase<bool?> {
  bool? value;

  SwitchForm({
    required String key,
    required String label,
    this.value,
  }) : super(key: key, label: label, type: 'switch');

  @override
  Widget build() {
    return FormBuilderSwitch(
      name: key,
      title: Text(label),
      initialValue: value,
    );
  }
}
