part of 'api_server.dart';

class ProductApi {
  static String baseUrl = '/product';
  static Future<ResponseBody> getList() async {
    ResponseBody response = await ApiServer.request(Method.get, '/product/list');
    return response;
  }

  static Future<ResponseBody> getTransactionCategory(String key) async {
    ResponseBody response = await ApiServer.request(Method.get, '/product/$key/transCategory');
    return response;
  }

  static Future<ResponseBody> getCategorymappingTree(String productKey, {required int accountId}) async {
    ResponseBody response = await ApiServer.request(
      Method.get,
      '/account/$accountId/product/$productKey/transCategory/mapping/tree',
    );
    return response;
  }

  static Future<ResponseBody> mappingTransactionCategory(
      TransactionCategoryModel transactionCategory, int productTransactionCategoryId) async {
    ResponseBody response = await ApiServer.request(
      Method.post,
      '/account/${transactionCategory.accountId}/product/transCategory/$productTransactionCategoryId/mapping',
      data: {'CategoryId': transactionCategory.id},
    );
    return response;
  }

  static Future<ResponseBody> deleteTransactionCategoryMapping(
      TransactionCategoryModel transactionCategory, int productTransactionCategoryId) async {
    ResponseBody response = await ApiServer.request(
      Method.delete,
      '/account/${transactionCategory.accountId}/product/transCategory/$productTransactionCategoryId/mapping',
      data: {'CategoryId': transactionCategory.id},
    );
    return response;
  }

  static Future<ResponseBody> uploadBill(String productKey, String filePath, {required int accountId}) async {
    ResponseBody response = await ApiServer.request(Method.post, '/account/$accountId/product/$productKey/bill/import',
        data: FormData.fromMap({'File': await MultipartFile.fromFile(filePath)}));
    return response;
  }
}
