import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:leap_ledger_app/widget/toast.dart';

class UserForgetPassword extends StatefulWidget {
  const UserForgetPassword({Key? key}) : super(key: key);
  @override
  UserForgetPasswordState createState() => UserForgetPasswordState();
}

class UserForgetPasswordState extends State<UserForgetPassword> {
  late TextEditingController pwdController;
  bool? checked = false;

  @override
  void initState() {
    super.initState();
    pwdController = TextEditingController();
  }

  @override
  void dispose() {
    pwdController.dispose();
    super.dispose();
  }

  final GlobalKey<CommonEmailCaptchaFormState> emailCaptchaKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserUpdatePasswordSuccess) {
              tipToast("修改成功");
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "忘记密码",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 42,
                    ),
                  ),
                ),
                CommonEmailCaptcha(
                  UserAction.forgetPassword,
                  formKey: emailCaptchaKey,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '密码',
                  ),
                  controller: pwdController,
                  obscureText: true,
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
          child: Text('修改', style: Theme.of(context).primaryTextTheme.headlineSmall),
          onPressed: () {
            triggerUpdateEvent();
          },
        ),
      ),
    );
  }

  void triggerUpdateEvent() {
    var email = "";
    var captcha = "";
    if (emailCaptchaKey.currentState != null) {
      email = emailCaptchaKey.currentState!.getEmail();
      captcha = emailCaptchaKey.currentState!.getEmailCaptcha();
    }
    var password = pwdController.value.text;
    var event = UserPasswordUpdateEvent(email, password, captcha, UserAction.forgetPassword);
    BlocProvider.of<UserBloc>(context).add(event);
  }
}
