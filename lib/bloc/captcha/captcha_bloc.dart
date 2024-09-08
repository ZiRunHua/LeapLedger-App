import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/api/model/model.dart';

part 'captcha_event.dart';
part 'captcha_state.dart';

class CaptchaBloc extends Bloc<CaptchaEvent, CaptchaState> {
  static String currentCaptchaId = "";
  CommonCaptchaModel model = CommonCaptchaModel.fromJson({});
  CaptchaBloc() : super(CaptchaInitial()) {
    on<CaptchaLoadEvent>(_load);
  }
  _load(CaptchaLoadEvent event, Emitter<CaptchaState> emit) async {
    model = await CommonApi.getCaptcha();
    currentCaptchaId = model.captchaId;
    int index = model.picBase64.indexOf("base64,");
    if (index != -1) {
      model.picBase64 = model.picBase64.substring(index + "base64,".length);
    }
    emit(CaptchaLoaded(model.picBase64));
  }
}
