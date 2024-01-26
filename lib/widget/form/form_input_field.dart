part of 'form.dart';

class FormInputField {
  static Widget string(String fieldName, String initialValue, void Function(String)? onChanged) {
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

  static Widget general<T>({
    String? fieldName,
    T? initialValue,
    void Function(T?)? onChanged,
    void Function(T?)? onSave,
    String? Function(T?)? validator,
    InputDecoration? decoration,
    bool enabled = true,
  }) {
    assert(decoration == null || fieldName == null);
    late final T? Function(String? value) handleValue;
    late final String? initialValueString;
    late final TextInputType type;
    switch (T) {
      case String:
        handleValue = ((String? value) => value) as T? Function(String? value);
        initialValueString = initialValue as String?;
        type = TextInputType.text;
        break;
      case int:
        handleValue = Data.stringToInt as T? Function(String? value);
        initialValueString = Data.intToString(initialValue as int?);
        type = TextInputType.number;
        break;
      case double:
        handleValue = Data.stringToDouble as T? Function(String? value);
        initialValueString = Data.doubleToString(initialValue as double?);
        type = TextInputType.number;
        break;
      default:
        // 默认当作字符串
        handleValue = ((String? value) => value) as T? Function(String? value);
        initialValueString = initialValue as String?;
        type = TextInputType.text;
        break;
    }
    return TextFormField(
      enabled: enabled,
      initialValue: initialValueString,
      keyboardType: type,
      decoration: decoration ??
          InputDecoration(
            labelText: fieldName,
            border: const OutlineInputBorder(),
          ),
      onChanged: (String? value) {
        if (onChanged != null) {
          onChanged(handleValue(value));
        }
      },
      onSaved: (String? value) {
        if (onSave != null) {
          onSave(handleValue(value));
        }
      },
      validator: (value) {
        if (validator != null) {
          return validator(handleValue(value));
        }
        return null;
      },
    );
  }

  static Widget searchInput({
    void Function(String?)? onChanged,
    void Function(String?)? onSave,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text("搜索："),
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            border: UnderlineInputBorder(), // 添加边框
          ),
          onChanged: (String? value) {
            if (onChanged != null) {
              onChanged(value);
            }
          },
          onSaved: (String? value) {
            if (onSave != null) {
              onSave(value);
            }
          },
        ))
      ],
    );
  }
}
