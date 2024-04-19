part of 'common.dart';

class CommonDialog extends AlertDialog {
  const CommonDialog({
    super.key,
    super.icon,
    super.iconPadding,
    super.iconColor,
    super.title,
    super.titlePadding,
    super.titleTextStyle,
    super.content,
    super.contentPadding,
    super.contentTextStyle,
    super.actions,
    super.actionsPadding,
    super.actionsAlignment,
    super.actionsOverflowAlignment,
    super.actionsOverflowDirection,
    super.actionsOverflowButtonSpacing,
    super.buttonPadding,
    super.backgroundColor,
    super.elevation,
    super.shadowColor,
    super.surfaceTintColor,
    super.semanticLabel,
    super.insetPadding,
    super.clipBehavior,
    super.shape,
    super.alignment,
    super.scrollable,
  });
  static Future<bool> showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) async {
    bool isFinish = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认删除？'),
          content: const Text('你确定要删除吗？'),
          actions: [
            TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop<bool>(false);
                }),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop<bool>(true);
              },
            ),
          ],
        );
      },
    ).then((value) => isFinish = value);
    return isFinish;
  }

  CommonDialog.edit(BuildContext context,
      {Key? key,
      required VoidCallback onSave,
      required Function getPopData,
      required String title,
      required Widget content,
      bool autoPop = true})
      : this(
          key: key,
          title: Text(title),
          content: content,
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(getPopData()), child: const Text('取消')),
            ElevatedButton(
                onPressed: () {
                  onSave();
                  if (autoPop) Navigator.of(context).pop(getPopData());
                },
                child: const Text('确定')),
          ],
        );
  static CommonDialog editOne<T>(BuildContext context,
      {Key? key,
      required void Function(T?) onSave,
      required String fieldName,
      required T? initValue,
      bool autoPop = true}) {
    return CommonDialog(
      key: key,
      title: Text(fieldName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FormInputField.general<T>(initialValue: initValue, onChanged: (value) => initValue = value)
            ],
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
        ElevatedButton(
            onPressed: () {
              onSave(initValue);
              if (autoPop) Navigator.of(context).pop();
            },
            child: const Text('确定')),
      ],
    );
  }
}
