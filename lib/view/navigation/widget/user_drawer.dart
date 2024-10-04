part of '../navigation.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Colors.grey.shade800;
    final double leftPadding = 48.w;
    return Drawer(
      width: max(MediaQuery.of(context).size.width * 2 / 3, 200.w),
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
              contentPadding: EdgeInsets.only(left: leftPadding),
              onTap: () {
                Navigator.pushNamed(context, UserRoutes.passwordUpdate);
              },
            ),
            ListTile(
              leading: Icon(Icons.library_books, color: iconColor),
              title: const Text('账本管理'),
              contentPadding: EdgeInsets.only(left: leftPadding),
              onTap: () => AccountRoutes.list(context, selectedCurrentAccount: true).push(),
            ),
            ListTile(
              leading: Icon(Icons.toggle_on_outlined, color: iconColor),
              title: const Text('分享配置'),
              contentPadding: EdgeInsets.only(left: leftPadding),
              onTap: () {
                Navigator.pushNamed(context, UserRoutes.configTransactionShare);
              },
            ),
            ListTile(
              leading: Icon(Icons.send_outlined, color: iconColor),
              title: const Text('邀请'),
              contentPadding: EdgeInsets.only(left: leftPadding),
              onTap: () {
                Navigator.pushNamed(context, UserRoutes.accountInvitation);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined, color: iconColor),
              title: const Text('退出'),
              contentPadding: EdgeInsets.only(left: leftPadding),
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
