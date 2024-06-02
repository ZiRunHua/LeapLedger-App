part of '../navigation.dart';

class UserDrawerHeader extends StatefulWidget {
  const UserDrawerHeader({super.key});

  @override
  State<UserDrawerHeader> createState() => _UserDrawerHeaderState();
}

class _UserDrawerHeaderState extends State<UserDrawerHeader> {
  UserModel get user => UserBloc.user;
  @override
  Widget build(BuildContext context) {
    return DividerTheme(
      data: const DividerThemeData(
        color: Colors.white,
      ),
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(backgroundImage: null, radius: 32.0, child: Icon(Icons.person, size: 32.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<UserBloc, UserState>(
                      builder: (_, state) {
                        return buildUsername(context);
                      },
                    ),
                    _buildEmail(context, user.email)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUsername(BuildContext context) {
    return FittedBox(
        fit: BoxFit.scaleDown,
        child: GestureDetector(
            onTap: () {
              onSubmit(String? value) {
                UserInfoUpdateModel model = UserInfoUpdateModel();
                model.username = value;
                BlocProvider.of<UserBloc>(context).add(UserInfoUpdateEvent(model));
              }

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CommonDialog.editOne<String>(context,
                        fieldName: "编辑昵称", initValue: user.username, onSave: onSubmit);
                  });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: user.uniqueUsername));
                      CommonToast.tipToast("用户名已复制");
                    },
                    child: Icon(
                      Icons.copy_outlined,
                      color: Colors.white,
                      size: 16,
                    ))
              ],
            )));
  }

  Widget _buildEmail(BuildContext context, String email) {
    List<String> splitStrings = email.split("@");
    if (splitStrings.length == 2 && email.length >= 25) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              splitStrings[0],
              style: const TextStyle(fontSize: ConstantFontSize.body),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                "@${splitStrings[1]}",
                style: const TextStyle(fontSize: ConstantFontSize.bodySmall),
              ))
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            email,
            style: const TextStyle(fontSize: ConstantFontSize.body),
          )
        ],
      );
    }
  }
}
