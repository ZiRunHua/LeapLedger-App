import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/current.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  UserLoginState createState() => UserLoginState();
}

class UserLoginState extends State<UserLogin> {
  late TextEditingController emailController;
  late TextEditingController pwdController;
  bool? checked = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: UserBloc.user.email);
    pwdController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  final GlobalKey<CommonCaptchaState> captchaKey = GlobalKey();
  bool displayCaptcha = false;
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event.runtimeType == KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
          onPressed();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PopScope(
          canPop: UserBloc.isLogin,
          child: SingleChildScrollView(
            child: BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserLoginedState) {
                  if (UserBloc.currentAccount.isValid) {
                    Navigator.pop(context, true);
                  } else {
                    Navigator.pushReplacementNamed(context, AccountRoutes.templateList);
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Constant.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80.h),
                    Padding(
                      padding: EdgeInsets.all(Constant.margin),
                      child: Text("登录", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 42)),
                    ),
                    SizedBox(height: 20.h),
                    TextField(decoration: const InputDecoration(labelText: '邮箱'), controller: emailController),
                    SizedBox(height: 20.h),
                    TextField(
                      decoration: const InputDecoration(labelText: '密码'),
                      controller: pwdController,
                      obscureText: true,
                      onTap: () => setState(() => displayCaptcha = true),
                    ),
                    Offstage(offstage: !displayCaptcha, child: CommonCaptcha(key: captchaKey)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () => CommonToast.tipToast("不开放注册，请点击“游客模式”"),
                            child: const Text("注册账号")),
                        TextButton(
                            onPressed: () => CommonToast.tipToast("不开放注册，请点击“游客模式”"),
                            child: const Text("忘记密码"))
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Padding(padding: EdgeInsets.all(Constant.padding), child: _buildTourButton()),
                    SizedBox(height: 30.h),
                    buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return Align(
      child: SizedBox(
        height: 36.h,
        width: 270.w,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: WidgetStateProperty.all(const StadiumBorder(side: BorderSide(style: BorderStyle.none)))),
          onPressed: onPressed,
          child: Text('登录', style: Theme.of(context).primaryTextTheme.headlineSmall),
        ),
      ),
    );
  }

  Widget _buildTourButton() {
    return Offstage(
      offstage: Current.deviceId == null,
      child: GestureDetector(
          onTap: () => RepositoryProvider.of<UserBloc>(context).add(UserRequestTourEvent()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rocket_launch_outlined, color: ConstantColor.primaryColor),
              Text(
                "游客模式",
                style: TextStyle(color: ConstantColor.primaryColor),
              ),
            ],
          )),
    );
  }

  onPressed() {
    String captcha = "";
    if (captchaKey.currentState != null) {
      captcha = captchaKey.currentState!.getCaptcha();
    }
    RepositoryProvider.of<UserBloc>(context)
        .add(UserLoginEvent(emailController.value.text, pwdController.value.text, captcha));
  }
}
