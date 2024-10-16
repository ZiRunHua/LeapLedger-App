import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:timezone/timezone.dart';
part 'form_input_field.dart';
part 'form_select_field.dart';
part 'form_button.dart';
part 'form_selecter.dart';

Widget saveButton(BuildContext context, Function(BuildContext context) submitForm) {
  return ElevatedButton(
    onPressed: () => submitForm(context),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: Constant.padding, horizontal: Constant.padding * 2),
    ),
    child: const Text(
      '保 存',
      style: TextStyle(fontSize: ConstantFontSize.largeHeadline),
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
