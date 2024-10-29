import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:leap_ledger_app/bloc/account/account_bloc.dart';
import 'package:leap_ledger_app/bloc/category/category_bloc.dart';
import 'package:leap_ledger_app/bloc/transaction/transaction_bloc.dart';
import 'package:leap_ledger_app/bloc/user/config/user_config_bloc.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leap_ledger_app/view/navigation/navigation.dart';
import 'common/global.dart';
import 'package:leap_ledger_app/common/current.dart';
import 'package:timezone/data/latest_all.dart' as tzData;
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  init().then((e) => runApp(MyApp()));
}

Future<void> init() async {
  //ScreenUtil
  await ScreenUtil.ensureScreenSize();
  //TimeZones
  tzData.initializeTimeZones();
  //SharedPreferencesCache
  await SharedPreferencesCache.init();
  //config
  await Global.init();
  await Current.init();
  //await Global.cache.clear();
  await initCache();
  Routes.init();
}

initCache() async {
  UserBloc.getToCache();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AccountBloc _accountBloc = AccountBloc();
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserBloc>(create: (context) => UserBloc(_accountBloc)),
          RepositoryProvider<UserConfigBloc>(create: (context) => UserConfigBloc()),
          RepositoryProvider<AccountBloc>(create: (context) => _accountBloc),
          RepositoryProvider<TransactionBloc>(create: (context) => TransactionBloc()),
          RepositoryProvider<CategoryBloc>(create: (context) => CategoryBloc()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 667),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              title: "LeapLedger",
              debugShowCheckedModeBanner: false,
              supportedLocales: const [
                Locale('zh', 'CN'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode &&
                      supportedLocale.countryCode == locale?.countryCode) {
                    Intl.defaultLocale = supportedLocale.languageCode;
                    return supportedLocale;
                  }
                }
                Intl.defaultLocale = supportedLocales.first.languageCode;
                return supportedLocales.first;
              },
              navigatorKey: Global.navigatorKey,
              theme: ThemeData(
                tabBarTheme: TabBarTheme(
                  dividerHeight: 0,
                  overlayColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
                colorScheme: const ColorScheme.light(
                  primary: ConstantColor.primaryColor,
                  secondary: ConstantColor.secondaryColor,
                ),
                primaryColor: ConstantColor.primaryColor,
                dividerColor: Colors.transparent,
                appBarTheme: AppBarTheme(
                  color: Colors.white,
                  shadowColor: ConstantColor.shadowColor,
                  surfaceTintColor: Colors.white,
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey),
                    foregroundColor: Colors.grey,
                    shape: const StadiumBorder(side: BorderSide(style: BorderStyle.none)),
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                ),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.blue,
                  shape: CircleBorder(),
                  // smallSizeConstraints: BoxConstraints(minWidth: 100),
                  // extendedSizeConstraints: BoxConstraints(minWidth: 100),
                ),
                iconTheme: IconThemeData.fallback().copyWith(applyTextScaling: true),
                useMaterial3: true,
              ),
              home: Navigation(),
              builder: (context, widget) {
                Constant.init();
                FlutterNativeSplash.remove();
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.sp)),
                  child: widget!,
                );
              },
              routes: Routes.routes,
              onGenerateRoute: Routes.generateRoute,
            );
          },
        ));
  }
}
