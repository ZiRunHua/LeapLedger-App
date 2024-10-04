import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:leap_ledger_app/widget/toast.dart';

class UserPasswordUpdate extends StatefulWidget {
  const UserPasswordUpdate({Key? key}) : super(key: key);
  @override
  UserPasswordUpdateState createState() => UserPasswordUpdateState();
}

class UserPasswordUpdateState extends State<UserPasswordUpdate> {
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('修改密码'),
      ),
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
                CommonEmailCaptcha(
                  UserAction.updatePassword,
                  formKey: emailCaptchaKey,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '密码',
                  ),
                  controller: pwdController,
                  obscureText: true,
                ),
                SizedBox(height: 70.h),
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
        height: 45.h,
        width: 270.w,
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
    var captcha = "";
    if (emailCaptchaKey.currentState != null) {
      captcha = emailCaptchaKey.currentState!.getEmailCaptcha();
    }
    var password = pwdController.value.text;
    var event = UserPasswordUpdateEvent("", password, captcha, UserAction.updatePassword);
    BlocProvider.of<UserBloc>(context).add(event);
  }
}
