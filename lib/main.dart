import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keepaccount_app/bloc/account/account_bloc.dart';
import 'package:keepaccount_app/bloc/transaction/transaction_bloc.dart';
import 'package:keepaccount_app/bloc/user/config/user_config_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/model/user/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:keepaccount_app/view/navigation/navigation.dart';
import 'common/global.dart';
import 'package:keepaccount_app/common/current.dart';

Future<void> main() async {
  init().then((e) => runApp(const MyApp()));
}

Future<void> init() async {
  const String envName = String.fromEnvironment("ENV");
  Current.env = ENV.values.firstWhere((e) => e.toString().split('.').last == envName);

  await SharedPreferencesCache.init();
  await Global.init();
  await initCache();
  Routes.init();

  //await Global.cache.clear();
  await Current.init();
}

initCache() async {
  UserBloc.getToCache();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserBloc>(create: (context) => UserBloc()),
          RepositoryProvider<UserConfigBloc>(create: (context) => UserConfigBloc()),
          RepositoryProvider<AccountBloc>(create: (context) => AccountBloc()),
          RepositoryProvider<TransactionBloc>(create: (context) => TransactionBloc()),
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
          navigatorKey: Global.navigatorKey,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: ConstantColor.primaryColor,
              secondary: ConstantColor.secondaryColor,
            ),
            primaryColor: ConstantColor.primaryColor,
            dividerColor: Colors.transparent,
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
          home: MultiBlocListener(listeners: [
            BlocListener<AccountBloc, AccountState>(
              listener: (context, state) {
                if (state is AccountDeleteSuccess) {
                  var newCurrentInfo = state.currentInfo;
                  if (UserBloc.currentAccount.id != newCurrentInfo.currentAccount.id) {
                    BlocProvider.of<UserBloc>(context).add(SetCurrentAccount(state.currentInfo.currentAccount));
                  }
                  if (UserBloc.currentShareAccount.id != newCurrentInfo.currentShareAccount.id) {
                    BlocProvider.of<UserBloc>(context)
                        .add(SetCurrentShareAccount(state.currentInfo.currentShareAccount));
                  }
                } else if (state is AccountSaveSuccess) {
                  BlocProvider.of<UserBloc>(context).add(UpdateCurrentInfoEvent(
                      UserCurrentModel(currentAccount: state.account, currentShareAccount: state.account)));
                }
              },
            )
          ], child: Navigation()),
          // TransactionChart(
          //       account: UserBloc.currentAccount,
          //     )
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
