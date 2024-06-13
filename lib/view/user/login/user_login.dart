import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/current.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/widget/common/common.dart';

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
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event.runtimeType == RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
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
                padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    const Padding(
                      padding: EdgeInsets.all(Constant.margin),
                      child: Text("登录", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42)),
                    ),
                    const SizedBox(height: 20),
                    TextField(decoration: const InputDecoration(labelText: '邮箱'), controller: emailController),
                    const SizedBox(height: 20),
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
                            onPressed: () => Navigator.pushNamed(context, UserRoutes.register),
                            child: const Text("注册账号")),
                        TextButton(
                            onPressed: () => Navigator.pushNamed(context, UserRoutes.forgetPassword),
                            child: const Text("忘记密码"))
                      ],
                    ),
                    const SizedBox(height: 40),
                    Padding(padding: const EdgeInsets.all(Constant.padding), child: _buildTourButton()),
                    const SizedBox(height: 30),
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
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const StadiumBorder(side: BorderSide(style: BorderStyle.none)))),
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
