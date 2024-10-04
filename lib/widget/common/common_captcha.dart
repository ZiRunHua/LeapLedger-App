part of 'common.dart';

class CommonCaptcha extends StatefulWidget {
  const CommonCaptcha({Key? key}) : super(key: key);
  @override
  CommonCaptchaState createState() => CommonCaptchaState();
}

class CommonCaptchaState extends State<CommonCaptcha> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CaptchaBloc(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 80,
            child: TextField(
              decoration: const InputDecoration(
                labelText: '验证码',
              ),
              controller: controller,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const CaptchaPic(),
        ],
      ),
    );
  }

  String getCaptcha() {
    return controller.value.text;
  }
}

class CaptchaPic extends StatelessWidget {
  const CaptchaPic({super.key});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CaptchaBloc>(context).add(CaptchaLoadEvent());
    return BlocBuilder<CaptchaBloc, CaptchaState>(
      builder: (_, state) {
        if (state is CaptchaLoaded) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(
                base64Decode(state.picBase64),
                fit: BoxFit.cover,
                width: 180.w,
                height: 50.sp,
              ),
              CaptchaButton(0)
            ],
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.grey,
              width: 180.w,
              height: 50.sp,
            ),
            CaptchaButton(0)
          ],
        );
      },
    );
  }
}

class CaptchaButton extends StatefulWidget {
  final int _countdown;

  CaptchaButton(this._countdown) : super(key: UniqueKey());

  @override
  CaptchaButtonState createState() => CaptchaButtonState();
}

class CaptchaButtonState extends State<CaptchaButton> {
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
      return TextButton(
        onPressed: null,
        child: Text(
          "$currentCount秒后",
          style: const TextStyle(
            color: Colors.grey,
            backgroundColor: Colors.white,
          ),
        ),
      );
    } else {
      return TextButton(
          onPressed: () {
            BlocProvider.of<CaptchaBloc>(context).add(CaptchaLoadEvent());
          },
          child: const Text(
            "换一张",
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
