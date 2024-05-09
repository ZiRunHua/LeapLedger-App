import 'package:flutter/material.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';
part 'form_input_field.dart';
part 'form_button.dart';
part 'form_selecter.dart';

Widget saveButton(BuildContext context, Function(BuildContext context) submitForm) {
  return ElevatedButton(
    onPressed: () => submitForm(context),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
    ),
    child: const Text(
      '保 存',
      style: TextStyle(
        fontSize: 18.0,
      ),
    ),
  );
}

Widget stringForm(String fieldName, String initialValue, void Function(String)? onChanged) {
  return TextFormField(
    initialValue: initialValue,
    decoration: InputDecoration(
      labelText: fieldName,
      border: const OutlineInputBorder(),

      // You can further style the input here
    ),
    onChanged: onChanged,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '请输入一个$fieldName';
      }
      return null;
    },
  );
}
