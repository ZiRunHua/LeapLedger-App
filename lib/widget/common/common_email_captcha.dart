part of 'common.dart';

/*
  根据传入type类型的不同来决定是否展示邮件输入框 以及之后相应不同的处理
*/
class CommonEmailCaptcha extends StatelessWidget {
  final UserAction type;
  final Key? formKey;
  const CommonEmailCaptcha(this.type, {super.key, this.formKey});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailCaptchaBloc(),
      child: CommonEmailCaptchaForm(
        type,
        key: formKey,
      ),
    );
  }
}

class CommonEmailCaptchaForm extends StatefulWidget {
  final UserAction type;
  const CommonEmailCaptchaForm(this.type, {Key? key}) : super(key: key);

  @override
  CommonEmailCaptchaFormState createState() => CommonEmailCaptchaFormState();
}

class CommonEmailCaptchaFormState extends State<CommonEmailCaptchaForm> {
  late TextEditingController emailController, emailCaptchaController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    emailCaptchaController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailCaptchaController.dispose();
    super.dispose();
  }

  final GlobalKey<CommonCaptchaState> captchaKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailCaptchaBloc, EmailCaptchaState>(
        listener: (_, state) {
          if (state is EmailCaptchaLoading) {
            String email = getEmail();
            String captcha = getCaptcha();
            BlocProvider.of<EmailCaptchaBloc>(context)
                .add(EmailCaptchaLoadEvent(email, captcha, CaptchaBloc.currentCaptchaId, widget.type));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Constant.margin),
            CommonCaptcha(key: captchaKey),
            Visibility(
                visible: emailTextVisibility(),
                child: TextField(
                  decoration: const InputDecoration(labelText: '邮箱'),
                  controller: emailController,
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180.w,
                  child: TextField(
                    maxLength: 6,
                    decoration: const InputDecoration(labelText: '邮箱验证码'),
                    controller: emailCaptchaController,
                  ),
                ),
                SizedBox(width: Constant.margin),
                buildSendButton(),
              ],
            ),
          ],
        ));
  }

  bool emailTextVisibility() {
    switch (widget.type) {
      //更新密码
      case UserAction.updatePassword:
        return false;
      //其余例如注册、忘记密码
      default:
        return true;
    }
  }

  Widget buildSendButton() {
    return BlocBuilder<EmailCaptchaBloc, EmailCaptchaState>(builder: (_, state) {
      if (state is EmailCaptchaLoaded) {
        return SendButton(state.countdown);
      } else {
        return SendButton(0);
      }
    });
  }

  String getEmail() {
    return emailController.value.text;
  }

  String getEmailCaptcha() {
    return emailCaptchaController.value.text;
  }

  String getCaptcha() {
    if (captchaKey.currentState == null) {
      return "";
    }
    return captchaKey.currentState!.getCaptcha();
  }
}

class SendButton extends StatefulWidget {
  final int _countdown;

  SendButton(this._countdown) : super(key: UniqueKey());

  @override
  SendButtonState createState() => SendButtonState();
}

class SendButtonState extends State<SendButton> {
  late int currentCount;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    currentCount = widget._countdown;
    startCountDown();
  }

  void startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (currentCount > 0) {
          currentCount--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentCount > 0) {
      return OutlinedButton(
        onPressed: null,
        child: Text(
          "重发($currentCount秒后)",
          style: const TextStyle(
            color: Colors.grey,
            backgroundColor: Colors.white,
          ),
        ),
      );
    } else {
      return OutlinedButton(
          onPressed: () {
            BlocProvider.of<EmailCaptchaBloc>(context).add(ClickSendButtonEvent());
          },
          child: const Text(
            "发送验证邮件",
            style: TextStyle(
              backgroundColor: Colors.white,
            ),
          ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
