part of 'enter.dart';

abstract class FormFieldBase<T> {
  final String key;
  final String label;
  final bool required;
  final bool enabled;
  final Function(T?)? onChange;
  T? value;
  FormFieldBase(
      {required this.key,
      required this.label,
      this.required = false,
      this.value = null,
      this.enabled = true,
      this.onChange});

  Widget build();
}

class TextFieldForm extends FormFieldBase<String?> {
  @override
  String? value;
  final String? hint;
  final List<Map<String, dynamic>>? validators;
  final int? maxLines;
  TextFieldForm({
    required super.key,
    required super.label,
    super.required,
    super.value,
    super.enabled,
    super.onChange,
    this.hint,
    this.validators,
    this.maxLines,
  });

  @override
  Widget build() {
    return FormBuilderTextField(
      name: key,
      decoration: InputDecoration(labelText: label, hintText: hint),
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
      enabled: enabled,
      onChanged: onChange,
      maxLines: maxLines,
    );
  }
}

class CheckboxForm extends FormFieldBase<bool?> {
  @override
  bool? value;

  CheckboxForm({
    required super.key,
    required super.label,
    super.required,
    this.value,
  });

  @override
  FormBuilderCheckbox build() {
    return FormBuilderCheckbox(
      name: key,
      title: Text(label),
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
      enabled: enabled,
      onChanged: onChange,
    );
  }
}

class CheckboxGroupForm<T extends Comparable> extends FormFieldBase<List<T>?> {
  final List<SelectOption<T>>? options;
  @override
  List<T>? value;

  CheckboxGroupForm({
    required super.key,
    required super.label,
    super.required,
    this.options,
    this.value,
  });

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
      enabled: enabled,
      onChanged: onChange,
    );
  }
}

class ChoiceChipForm<T extends Comparable> extends FormFieldBase<T?> {
  final List<SelectOption<T>>? options;
  @override
  T? value;

  ChoiceChipForm({
    required super.key,
    required super.label,
    super.required,
    this.options,
    this.value,
  });

  @override
  Widget build() {
    return FormBuilderChoiceChip<T>(
      name: key,
      decoration: InputDecoration(labelText: label),
      spacing: Constant.margin,
      options:
          options?.map((option) => FormBuilderChipOption<T>(value: option.value, child: Text(option.name))).toList() ??
              [],
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
      enabled: enabled,
      onChanged: onChange,
    );
  }
}

class DateRangePickerForm extends FormFieldBase<DateTimeRange?> {
  @override
  DateTimeRange? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  DateRangePickerForm({
    required super.key,
    required super.label,
    super.required,
    this.value,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build() {
    return FormBuilderDateRangePicker(
      name: key,
      decoration: InputDecoration(labelText: label),
      initialValue: value,
      firstDate: firstDate ?? Constant.minDateTime,
      lastDate: lastDate ?? Constant.maxDateTime,
      validator: required == true ? FormBuilderValidators.required() : null,
      enabled: enabled,
      onChanged: onChange,
    );
  }
}

class DateTimePickerForm extends FormFieldBase<DateTime?> {
  @override
  DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;

  DateTimePickerForm({
    required super.key,
    required super.label,
    super.required,
    this.value,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build() {
    return FormBuilderDateTimePicker(
      name: key,
      decoration: InputDecoration(labelText: label),
      initialValue: value,
      firstDate: firstDate ?? Constant.minDateTime,
      lastDate: lastDate ?? Constant.maxDateTime,
      validator: required == true ? FormBuilderValidators.required() : null,
      enabled: enabled,
      onChanged: onChange,
    );
  }
}

class DropdownForm<T extends Comparable> extends FormFieldBase<T?> {
  final List<SelectOption<T>> items;
  @override
  T? value;

  DropdownForm({
    required super.key,
    required super.label,
    super.required,
    this.value,
    required this.items,
  });

  @override
  Widget build() {
    return FormBuilderDropdown<T>(
      name: key,
      decoration: InputDecoration(labelText: label),
      initialValue: value,
      items: items.map((item) => DropdownMenuItem<T>(value: item.value, child: Text(item.name))).toList(),
      validator: required == true ? FormBuilderValidators.required() : null,
      enabled: enabled,
      onChanged: onChange,
    );
  }
}

class FilterChipForm<T extends Comparable> extends FormFieldBase<List<T>?> {
  @override
  List<T>? value;
  final List<SelectOption<T>> options;

  FilterChipForm({
    required super.key,
    required super.label,
    super.required,
    required this.options,
    this.value,
  });

  @override
  Widget build() {
    return FormBuilderFilterChip<T>(
      name: key,
      decoration: InputDecoration(labelText: label),
      spacing: Constant.margin,
      options: options.map((item) => FormBuilderChipOption<T>(value: item.value, child: Text(item.name))).toList(),
      initialValue: value,
      validator: required == true ? FormBuilderValidators.required() : null,
      enabled: enabled,
      onChanged: onChange,
    );
  }
}

class RadioGroupForm<T extends Comparable> extends FormFieldBase<T?> {
  @override
  T? value;
  final List<SelectOption<T>> options;

  RadioGroupForm({
    required super.key,
    required super.label,
    super.required,
    this.value,
    required this.options,
  });

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
      enabled: enabled,
      onChanged: onChange,
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
    required super.key,
    required super.label,
    this.value,
    required this.min,
    required this.max,
    this.divisions = 1,
  });

  @override
  Widget build() {
    return FormBuilderRangeSlider(
      name: key,
      decoration: InputDecoration(labelText: label),
      min: min,
      max: max,
      initialValue: value,
      divisions: divisions.toInt(),
      enabled: enabled,
      onChanged: onChange,
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
    required super.key,
    required super.label,
    this.value,
    required this.min,
    required this.max,
    this.divisions = 1,
  });

  @override
  Widget build() {
    return FormBuilderSlider(
      name: key,
      decoration: InputDecoration(labelText: label),
      min: min,
      max: max,
      initialValue: value ?? 0,
      divisions: divisions,
      enabled: enabled,
      onChanged: onChange,
    );
  }
}

class SwitchForm extends FormFieldBase<bool?> {
  @override
  bool? value;

  SwitchForm({
    required super.key,
    required super.label,
    this.value,
  });

  @override
  Widget build() {
    return FormBuilderSwitch(
      name: key,
      title: Text(label),
      initialValue: value,
      enabled: enabled,
      onChanged: onChange,
    );
  }
}
