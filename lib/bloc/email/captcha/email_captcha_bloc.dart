import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/common/global.dart';

part 'email_captcha_event.dart';
part 'email_captcha_state.dart';

class EmailCaptchaBloc extends Bloc<EmailCaptchaEvent, EmailCaptchaState> {
  int countdown = 0;
  EmailCaptchaBloc() : super(EmailCaptchaInitial()) {
    on<EmailCaptchaLoadEvent>(_load);
    on<ClickSendButtonEvent>(_getFormData);
  }
  _load(EmailCaptchaLoadEvent event, Emitter<EmailCaptchaState> emit) async {
    ResponseBody response;
    switch (event.type) {
      //更新密码调用用户模块接口
      case UserAction.updatePassword:
        response = await UserApi.sendEmailCaptcha(event.captcha, event.captchaId, event.type);
      //其余例如注册、忘记密码使用公共接口
      default:
        response = await CommonApi.sendEmailCaptcha(event.email, event.captcha, event.captchaId, event.type);
    }

    if (response.isSuccess) {
      countdown = response.data['ExpirationTime'];
      emit(EmailCaptchaLoaded(countdown));
    }
  }

  _getFormData(ClickSendButtonEvent event, Emitter<EmailCaptchaState> emit) async {
    emit(EmailCaptchaLoading());
  }
}
