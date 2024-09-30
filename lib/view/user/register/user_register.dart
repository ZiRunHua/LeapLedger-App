import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:leap_ledger_app/widget/toast.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  UserRegisterState createState() => UserRegisterState();
}

class UserRegisterState extends State<UserRegister> {
  late TextEditingController usernameController;
  late TextEditingController pwdController;
  bool? checked = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    pwdController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  final GlobalKey<CommonEmailCaptchaFormState> emailCaptchaKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserRegisterSuccessState) {
              tipToast("注册成功");
              Navigator.pushNamedAndRemoveUntil(context, AccountRoutes.templateList, ModalRoute.withName(Routes.home));
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
                  child: Text(
                    "注册",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 42,
                    ),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '昵称',
                  ),
                  controller: usernameController,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '密码',
                  ),
                  controller: pwdController,
                  obscureText: true,
                ),
                CommonEmailCaptcha(
                  UserAction.register,
                  formKey: emailCaptchaKey,
                ),
                const SizedBox(
                  height: 70,
                ),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: WidgetStateProperty.all(const StadiumBorder(side: BorderSide(style: BorderStyle.none)))),
          child: Text('注册', style: Theme.of(context).primaryTextTheme.headlineSmall),
          onPressed: () {
            triggerRegisterEvent();
          },
        ),
      ),
    );
  }

  void triggerRegisterEvent() {
    var email = "";
    var captcha = "";
    if (emailCaptchaKey.currentState != null) {
      email = emailCaptchaKey.currentState!.getEmail();
      captcha = emailCaptchaKey.currentState!.getEmailCaptcha();
    }
    var username = usernameController.value.text;
    var password = pwdController.value.text;
    var event = UserRegisterEvent(email, username, password, captcha);
    BlocProvider.of<UserBloc>(context).add(event);
  }
}
