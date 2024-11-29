part of 'routes.dart';

class AppRoutes {
  static AppSettingNavigator setting(BuildContext context) => AppSettingNavigator(context);
}

class AppSettingNavigator extends RouterNavigator {
  AppSettingNavigator(BuildContext context) : super(context: context);
  Future<bool> push() async => await _push(context, AppSetting());
}
