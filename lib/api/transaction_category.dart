part of 'api_server.dart';

class TransactionCategoryApi {
  static String baseUrl = '/transaction/category';
  static TransactionCategoryApiData dataFormatFunc = TransactionCategoryApiData();
  static Future<ResponseBody> getTree({IncomeExpense? type, int? accountId}) async {
    accountId ??= UserBloc.currentAccount.id;

    ResponseBody response = await ApiServer.request(
      Method.get,
      '$baseUrl/tree',
      data: {'AccountId': accountId, 'IncomeExpense': type?.name},
    );
    if (response.isSuccess && response.data['Tree'] is List) {
      response.data['Tree'] = response.data['Tree'].map((value) {
        value['AccountId'] = accountId;
        if (value['Children'] is List) {
          value['Children'] = value['Children'].map((value) {
            value['AccountId'] = accountId;
            return value;
          }).toList();
        }
        return value;
      }).toList();
    }
    return response;
  }

  static Future<List<TransactionCategoryModel>> getListByCond(
      {required int accountId, required CategoryQueryCond cond}) async {
    ResponseBody response = await ApiServer.request(
      Method.get,
      '$baseUrl/list',
      data: {'AccountId': accountId, 'IncomeExpense': cond.type?.name},
    );
    List<TransactionCategoryModel> list = [];
    if (response.isSuccess && response.data['List'] is List) {
      for (var element in response.data['List']) {
        list.add(TransactionCategoryModel.fromJson(element));
      }
    }
    return list;
  }

  static Future<ResponseBody> getTreeByCond({
    required int accountId,
    required CategoryQueryCond cond,
  }) async {
    ResponseBody response = await ApiServer.request(
      Method.get,
      '$baseUrl/tree',
      data: {'AccountId': accountId, 'IncomeExpense': cond.type?.name},
    );
    return response;
  }

  static Future<ResponseBody> moveCategory(int id, {int? previous, int? parentId}) async {
    return await ApiServer.request(Method.post, '$baseUrl/$id/move',
        data: {'Previous': previous, 'FatherId': parentId});
  }

  static Future<ResponseBody> moveCategoryParent(int id, {int? previous}) async {
    return await ApiServer.request(Method.post, '$baseUrl/father/$id/move', data: {'Previous': previous});
  }

  static Future<TransactionCategoryModel?> addCategory(TransactionCategoryModel model) async {
    var response = await ApiServer.request(Method.post, baseUrl, data: model.toJson());
    if (response.isSuccess) {
      return TransactionCategoryModel.fromJson(response.data);
    }
    return null;
  }

  static Future<TransactionCategoryFatherModel?> addCategoryParent(TransactionCategoryFatherModel model) async {
    var response = await ApiServer.request(Method.post, '$baseUrl/father', data: model.toJson());
    if (response.isSuccess) {
      return TransactionCategoryFatherModel.fromJson(response.data);
    }
    return null;
  }

  static Future<ResponseBody> deleteCategory(int id) async {
    return await ApiServer.request(Method.delete, '$baseUrl/$id');
  }

  static Future<ResponseBody> deleteCategoryParent(int id) async {
    return await ApiServer.request(Method.delete, '$baseUrl/father/$id');
  }

  static Future<TransactionCategoryModel?> updateCategory(TransactionCategoryModel model) async {
    var response = await ApiServer.request(Method.put, '$baseUrl/${model.id}', data: model.toJson());
    if (response.isSuccess) {
      return TransactionCategoryModel.fromJson(response.data);
    }
    return null;
  }

  static Future<TransactionCategoryFatherModel?> updateCategoryParent(TransactionCategoryFatherModel model) async {
    var response = await ApiServer.request(Method.put, '$baseUrl/father/${model.id}', data: model.toJson());
    if (response.isSuccess) {
      return TransactionCategoryFatherModel.fromJson(response.data);
    }
    return null;
  }

  static Future<bool> mappingCategory({required int parentId, required int childId}) async {
    var response = await ApiServer.request(Method.post, '$baseUrl/$parentId/mapping', data: {
      "ChildCategoryId": childId,
    });
    return response.isSuccess;
  }

  static Future<bool> deleteCategoryMapping({required int parentId, required int childId}) async {
    var response = await ApiServer.request(Method.delete, '$baseUrl/$parentId/mapping', data: {
      "ChildCategoryId": childId,
    });
    return response.isSuccess;
  }

  static Future<List<TransactionCategoryMappingTreeNodeApiModel>> getCategoryMappingTree(
      {required int parentAccountId, required int childAccountId}) async {
    var response = await ApiServer.request(Method.get, '$baseUrl/mapping/tree', data: {
      "ParentAccountId": parentAccountId,
      "ChildAccountId": childAccountId,
    });
    List<TransactionCategoryMappingTreeNodeApiModel> result = [];
    if (response.isSuccess && response.data['Tree'] is List) {
      for (var element in response.data['Tree']) {
        result.add(TransactionCategoryMappingTreeNodeApiModel.fromJson(element));
      }
    }
    return result;
  }
}

class TransactionCategoryApiData {
  List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> getTreeDataToList(
      ResponseBody response) {
    List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> result = [];
    if (response.isSuccess && response.data['Tree'] != null) {
      for (LinkedHashMap<String, dynamic> data in response.data['Tree']) {
        List<TransactionCategoryModel> children = [];
        TransactionCategoryFatherModel father = TransactionCategoryFatherModel.fromJson(data);
        for (Map<String, dynamic> child in data['Children']) {
          children.add(TransactionCategoryModel.fromJson(child)..fatherId = father.id);
        }
        result.add(MapEntry(father, children));
      }
    }
    return result;
  }

  List<TransactionCategoryModel> getCategoryListByTree(ResponseBody response) {
    List<TransactionCategoryModel> categoryList = [];
    if (response.isSuccess && response.data['Tree'] != null) {
      for (LinkedHashMap<String, dynamic> data in response.data['Tree']) {
        TransactionCategoryFatherModel father = TransactionCategoryFatherModel.fromJson(data);
        for (Map<String, dynamic> child in data['Children']) {
          categoryList.add(TransactionCategoryModel.fromJson(child)..fatherId = father.id);
        }
      }
    }
    return categoryList;
  }
}
