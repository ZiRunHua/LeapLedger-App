import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init().then((e) => runApp(MyApp()));
}

Future<void> init() async {
  tzData.initializeTimeZones();
  await SharedPreferencesCache.init();
  await Global.init();
  //await Global.cache.clear();
  await initCache();
  Routes.init();
  await Current.init();
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
        child: MaterialApp(
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
          title: 'Flutter Demo',
          theme: ThemeData(
            tabBarTheme: const TabBarTheme(
              dividerHeight: 0,
              overlayColor: WidgetStatePropertyAll<Color>(
                Colors.white,
              ),
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
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          home: Navigation(),
          builder: EasyLoading.init(builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          }),
          routes: Routes.routes,
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}
