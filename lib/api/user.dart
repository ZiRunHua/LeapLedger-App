part of 'api_server.dart';

class UserApi {
  static String baseUrl = '/user';
  static Future<ResponseBody> login(String email, String password, String captchaId, String captcha) async {
    ResponseBody response = await ApiServer.request(Method.post, '$pubilcBaseUrl$baseUrl/login',
        data: {'Email': email, 'Password': password, 'CaptchaId': captchaId, 'Captcha': captcha});
    return response;
  }

  static Future<ResponseBody> register(String username, String password, String email, String captcha) async {
    ResponseBody response = await ApiServer.request(Method.post, '$pubilcBaseUrl$baseUrl/register',
        data: {'Username': username, 'Password': password, 'Email': email, 'Captcha': captcha});
    return response;
  }

  static Future<ResponseBody> setCurrentAccount(int accountId) async {
    ResponseBody response =
        await ApiServer.request(Method.put, '$baseUrl/client/current/account', data: {'Id': accountId});
    return response;
  }

  static Future<ResponseBody> sendEmailCaptcha(String captcha, String captchaId, UserAction type) async {
    ResponseBody response = await ApiServer.request(Method.post, '$baseUrl/current/captcha/email/send',
        data: {"Captcha": captcha, "CaptchaId": captchaId, "Type": type.name});
    if (response.isSuccess) {
      tipToast("邮件已发送请耐心等待");
    }
    return response;
  }

  static Future<ResponseBody> forgetPassword(String email, String password, String captcha) async {
    ResponseBody response = await ApiServer.request(Method.put, '$pubilcBaseUrl$baseUrl/password',
        data: {'Email': email, 'Password': password, 'Captcha': captcha});
    return response;
  }

  static Future<ResponseBody> updatePassword(String password, String captcha) async {
    ResponseBody response = await ApiServer.request(Method.put, '$baseUrl/current/password',
        data: {'Password': password, 'Captcha': captcha});
    return response;
  }

  static Future<ResponseBody> updateInfo(UserInfoUpdateModel user) async {
    ResponseBody response = await ApiServer.request(Method.put, '$baseUrl/current', data: user.toJson());
    return response;
  }

  static Future<UserHomeApiModel> getHome({required int accountId}) async {
    ResponseBody response = await ApiServer.request(Method.get, '$baseUrl/home', data: {"AccountId": accountId});
    return UserHomeApiModel.fromJson(response.data);
  }

  static Future<UserTransactionShareConfigModel?> getTransactionShareConfig() async {
    ResponseBody response = await ApiServer.request(Method.get, '$baseUrl/transaction/share/config');
    if (response.isSuccess == false) {
      return null;
    }
    return UserTransactionShareConfigModel.fromJson(response.data);
  }

  static Future<UserTransactionShareConfigModel?> updateTransactionShareConfig(
      {required UserTransactionShareConfigFlag flag, required bool status}) async {
    ResponseBody response = await ApiServer.request(Method.put, '$baseUrl/transaction/share/config', data: {
      'Flag': flag.name,
      'Status': status,
    });
    if (response.isSuccess == false) {
      return null;
    }
    return UserTransactionShareConfigModel.fromJson(response.data);
  }

  static Future<List<UserInfoModel>> getFriendList() async {
    ResponseBody response = await ApiServer.request(Method.get, '$baseUrl/friend/list');
    List<UserInfoModel> list = [];
    if (response.isSuccess == false || response.data['List'].runtimeType != List) {
      return [];
    }
    for (Map<String, dynamic> data in response.data['List']) {
      list.add(UserInfoModel.fromJson(data));
    }
    return list;
  }
}

enum UserTransactionShareConfigFlag {
  account,
  createTime,
  updateTime,
  remark,
}
