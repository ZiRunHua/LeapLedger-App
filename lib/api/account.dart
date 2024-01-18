part of 'api_server.dart';

class AccountApi {
  static String baseUrl = "/account";
  static Future<List<AccountModel>> getList() async {
    ResponseBody response = await ApiServer.request(Method.get, '$baseUrl/list');
    List<AccountModel> result = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> data in response.data['List']) {
        result.add(AccountModel.fromJson(data));
      }
    }
    return result;
  }

  static Future<AccountModel> getOne(int id) async {
    ResponseBody response = await ApiServer.request(Method.get, '$baseUrl/$id');
    return AccountModel.fromJson(response.data);
  }

  static Future<AccountModel?> add(AccountModel accountModel) async {
    ResponseBody responseBody = await ApiServer.request(Method.post, baseUrl, data: accountModel.toJson());
    if (false == responseBody.isSuccess) {
      return null;
    }
    return AccountModel.fromJson(responseBody.data);
  }

  static Future<ResponseBody> delete(int id) async {
    ResponseBody response = await ApiServer.request(Method.delete, '$baseUrl/$id');
    return response;
  }

  static Future<ResponseBody> update(AccountModel accountModel) async {
    ResponseBody response =
        await ApiServer.request(Method.put, '$baseUrl/${accountModel.id}', data: accountModel.toJson());
    return response;
  }

  static Future<List<AccountTemplateModel>> getTemplateList() async {
    ResponseBody response = await ApiServer.request(Method.get, '$baseUrl/template/list');
    List<AccountTemplateModel> result = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> data in response.data['List']) {
        result.add(AccountTemplateModel.fromJson(data));
      }
    }
    return result;
  }

  static Future<AccountModel> addAccountByTempalte(AccountTemplateModel model) async {
    ResponseBody response = await ApiServer.request(Method.post, '$baseUrl/form/template/${model.id}');
    AccountModel result;
    if (response.isSuccess) {
      result = AccountModel.fromJson(response.data);
    } else {
      result = AccountModel.fromJson({});
    }
    return result;
  }

  static Future<AccountModel?> initTransCategoryByTempalte({
    required AccountModel account,
    required AccountTemplateModel template,
  }) async {
    ResponseBody response = await ApiServer.request(Method.post, '$baseUrl/${account.id}/transaction/category/init',
        data: {'TemplateId': template.id});
    AccountModel? result;
    if (response.isSuccess) {
      result = AccountModel.fromJson(response.data);
    }
    return result;
  }
}



// Future<List<AccountModel>> getOne(int id) async {
//   Response response = await request('/account/$id', Method.get);
//   List<AccountModel> result = [];
//   for (Map<String, dynamic> data in response.data['list']) {
//     result.add(AccountModel.fromResponse(data));
//   }
//   return result;
// }
