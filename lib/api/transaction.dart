part of 'api_server.dart';

class TransactionApi {
  static String baseUrl = '/transaction';
  static TransactionCategoryApiData dataFormatFunc = TransactionCategoryApiData();

  static Future<TransactionModel?> add(TransactionEditModel model) async {
    ResponseBody response = await ApiServer.request(Method.post, baseUrl, data: model.toJson());
    if (false == response.isSuccess) {
      return null;
    }
    return TransactionModel.fromJson(response.data);
  }

  static Future<TransactionModel?> update(TransactionEditModel model) async {
    assert(model.id != null);
    ResponseBody response = await ApiServer.request(Method.put, "$baseUrl/${model.id!}", data: model.toJson());
    if (false == response.isSuccess) {
      return null;
    }
    return TransactionModel.fromJson(response.data);
  }

  static Future<ResponseBody> delete(int id) async {
    ResponseBody response = await ApiServer.request(Method.delete, "$baseUrl/$id");
    return response;
  }

  static Future<List<TransactionModel>> getList(TransactionQueryCondModel condition, int limit, int offset) async {
    var data = condition.toJson();
    data['Limit'] = limit;
    data['Offset'] = offset;
    var responseBody = await ApiServer.request(Method.get, '$baseUrl/list', data: data);
    List<TransactionModel> result = [];
    if (responseBody.isSuccess) {
      for (Map<String, dynamic> data in responseBody.data['List']) {
        result.add(TransactionModel.fromJson(data));
      }
    }
    return result;
  }

  static Future<InExStatisticModel?> getTotal(TransactionQueryCondModel condition) async {
    var data = condition.toJson();
    var responseBody = await ApiServer.request(Method.get, '$baseUrl/total', data: data);
    if (responseBody.isSuccess) {
      return InExStatisticModel.fromJson(responseBody.data);
    }
    return null;
  }

  static Future<List<DayAmountStatisticApiModel>> getDayStatistic({
    required int accountId,
    Set<int>? categoryIds,
    IncomeExpense? ie,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    var responseBody = await ApiServer.request(Method.get, '$baseUrl/day/statistic', data: {
      "AccountId": accountId,
      "CategoryIds": categoryIds,
      "IncomeExpense": ie?.name,
      "StartTime": Json.dateTimeToJson(startTime),
      "EndTime": Json.dateTimeToJson(endTime),
    });
    List<DayAmountStatisticApiModel> result = [];
    if (responseBody.isSuccess && responseBody.data['List'] is List) {
      for (Map<String, dynamic> data in responseBody.data['List'] as List) {
        result.add(DayAmountStatisticApiModel.fromJson(data));
      }
    }
    return result;
  }

  static Future<List<InExStatisticWithTimeModel>> getMonthStatistic(TransactionQueryCondModel condition) async {
    var responseBody = await ApiServer.request(Method.get, '$baseUrl/month/statistic', data: condition.toJson());
    List<InExStatisticWithTimeModel> result = [];
    if (responseBody.isSuccess) {
      for (Map<String, dynamic> data in responseBody.data['List']) {
        result.add(InExStatisticWithTimeModel.fromJson(data));
      }
    }
    return result;
  }

  static Future<List<TransactionCategoryAmountRankApiModel>> getCategoryAmountRank({
    required int accountId,
    Set<int>? categoryIds,
    required IncomeExpense ie,
    int? limit,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    var responseBody = await ApiServer.request(Method.get, '$baseUrl/category/amount/rank', data: {
      "AccountId": accountId,
      "CategoryIds": categoryIds,
      "IncomeExpense": ie.name,
      "Limit": limit,
      "StartTime": Json.dateTimeToJson(startTime),
      "EndTime": Json.dateTimeToJson(endTime),
    });
    List<TransactionCategoryAmountRankApiModel> result = [];
    if (responseBody.isSuccess && responseBody.data['List'] is List) {
      for (Map<String, dynamic> data in responseBody.data['List'] as List) {
        result.add(TransactionCategoryAmountRankApiModel.fromJson(data));
      }
    }
    return result;
  }

  static Future<List<TransactionModel>> getAmountRank({
    required int accountId,
    required IncomeExpense ie,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    var responseBody = await ApiServer.request(Method.get, '$baseUrl/amount/rank', data: {
      "AccountId": accountId,
      "IncomeExpense": ie.name,
      "StartTime": Json.dateTimeToJson(startTime),
      "EndTime": Json.dateTimeToJson(endTime),
    });
    List<TransactionModel> result = [];
    if (responseBody.isSuccess && responseBody.data['List'] is List) {
      for (Map<String, dynamic> data in responseBody.data['List'] as List) {
        result.add(TransactionModel.fromJson(data));
      }
    }
    return result;
  }
}
