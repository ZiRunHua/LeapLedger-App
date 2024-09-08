part of '../navigation.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Colors.grey.shade800;
    return Drawer(
      width: 280,
      backgroundColor: Colors.white,
      child: DefaultTextStyle(
        style: TextStyle(color: iconColor),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserDrawerHeader(),
            ListTile(
              leading: Icon(Icons.key, color: iconColor),
              title: const Text('修改密码'),
              contentPadding: const EdgeInsets.only(left: 48),
              onTap: () {
                Navigator.pushNamed(context, UserRoutes.passwordUpdate);
              },
            ),
            ListTile(
              leading: Icon(Icons.library_books, color: iconColor),
              title: const Text('账本管理'),
              contentPadding: const EdgeInsets.only(left: 48),
              onTap: () => AccountRoutes.list(context, selectedCurrentAccount: true).push(),
            ),
            ListTile(
              leading: Icon(Icons.toggle_on_outlined, color: iconColor),
              title: const Text('分享配置'),
              contentPadding: const EdgeInsets.only(left: 48),
              onTap: () {
                Navigator.pushNamed(context, UserRoutes.configTransactionShare);
              },
            ),
            ListTile(
              leading: Icon(Icons.send_outlined, color: iconColor),
              title: const Text('邀请'),
              contentPadding: const EdgeInsets.only(left: 48),
              onTap: () {
                Navigator.pushNamed(context, UserRoutes.accountInvitation);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined, color: iconColor),
              title: const Text('退出'),
              contentPadding: const EdgeInsets.only(left: 48),
              onTap: () {
                BlocProvider.of<UserBloc>(context).add(UserLogoutEvent());
                Navigator.popAndPushNamed(context, UserRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
