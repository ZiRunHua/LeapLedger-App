part of 'api_server.dart';

class TransactionApi {
  static String baseUrl = '/transaction';
  static TransactionCategoryApiData dataFormatFunc = TransactionCategoryApiData();
  static String _buildPrefix(int? accountId) {
    if (accountId == null) {
      return baseUrl;
    }
    return "/account/" + accountId.toString() + baseUrl;
  }

  static Future<TransactionModel?> add(TransactionEditModel model) async {
    ResponseBody response = await ApiServer.request(Method.post, _buildPrefix(model.accountId), data: model.toJson());
    if (false == response.isSuccess) {
      return null;
    }
    return TransactionModel.fromJson(response.data);
  }

  static Future<TransactionModel?> update(TransactionEditModel model) async {
    assert(model.isValid);
    ResponseBody response =
        await ApiServer.request(Method.put, _buildPrefix(model.accountId) + "/${model.id}", data: model.toJson());
    if (false == response.isSuccess) {
      return null;
    }
    return TransactionModel.fromJson(response.data);
  }

  static Future<ResponseBody> delete(int id, {required int accountId}) async {
    ResponseBody response = await ApiServer.request(Method.delete, _buildPrefix(accountId) + "/$id");
    return response;
  }

  static Future<List<TransactionModel>> getList(TransactionQueryCondModel condition, int limit, int offset) async {
    var data = condition.toJson();
    data['Limit'] = limit;
    data['Offset'] = offset;
    var responseBody = await ApiServer.request(Method.get, _buildPrefix(condition.accountId) + '/list', data: data);
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
    var responseBody = await ApiServer.request(Method.get, _buildPrefix(condition.accountId) + '/total', data: data);
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
    var responseBody = await ApiServer.request(Method.get, _buildPrefix(accountId) + '/day/statistic', data: {
      "AccountId": accountId,
      "CategoryIds": categoryIds,
      "IncomeExpense": ie?.name,
      "StartTime": startTime.toUtc().toIso8601String(),
      "EndTime": endTime.toUtc().toIso8601String(),
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
    var responseBody = await ApiServer.request(
      Method.get,
      _buildPrefix(condition.accountId) + '/month/statistic',
      data: condition.toJson(),
    );
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
    var responseBody = await ApiServer.request(Method.get, _buildPrefix(accountId) + '/category/amount/rank', data: {
      "AccountId": accountId,
      "CategoryIds": categoryIds,
      "IncomeExpense": ie.name,
      "Limit": limit,
      "StartTime": startTime.toUtc().toIso8601String(),
      "EndTime": endTime.toUtc().toIso8601String(),
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
    var responseBody = await ApiServer.request(Method.get, _buildPrefix(accountId) + '/amount/rank', data: {
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

  static Future<({TransactionInfoModel trans, TransactionTimingModel config})?> addTiming({
    required int accountId,
    required TransactionInfoModel trans,
    required TransactionTimingModel config,
  }) async {
    var responseBody = await ApiServer.request(Method.post, _buildPrefix(accountId) + '/timing', data: {
      "Trans": trans.toJson(),
      "Config": config.toJson(),
    });
    if (!responseBody.isSuccess) return null;
    trans = TransactionInfoModel.fromJson(responseBody.data["Trans"]);
    config = TransactionTimingModel.fromJson(responseBody.data["Config"]);
    return (trans: trans, config: config);
  }

  static Future<({TransactionInfoModel trans, TransactionTimingModel config})?> updateTiming({
    required int accountId,
    required TransactionInfoModel trans,
    required TransactionTimingModel config,
  }) async {
    var responseBody = await ApiServer.request(Method.put, _buildPrefix(accountId) + '/timing/${config.id}', data: {
      "Trans": trans.toJson(),
      "Config": config.toJson(),
    });
    if (!responseBody.isSuccess) return null;
    trans = TransactionInfoModel.fromJson(responseBody.data["Trans"]);
    config = TransactionTimingModel.fromJson(responseBody.data["Config"]);
    return (trans: trans, config: config);
  }

  static Future<List<({TransactionInfoModel trans, TransactionTimingModel config})>> getTimingList(
      {required int accountId, int offset = 0, int limit = 20}) async {
    var responseBody = await ApiServer.request(Method.get, _buildPrefix(accountId) + '/timing/list',
        data: {'Offset': offset, 'Limit': limit});
    List<({TransactionInfoModel trans, TransactionTimingModel config})> list = [];
    if (!responseBody.isSuccess) return list;

    if (responseBody.isSuccess && responseBody.data['List'] is List) {
      for (Map<String, dynamic> data in responseBody.data['List'] as List) {
        list.add((
          trans: TransactionInfoModel.fromJson(data["Trans"]),
          config: TransactionTimingModel.fromJson(data["Config"]),
        ));
      }
    }
    return list;
  }

  static Future<bool> deleteTiming({required int accountId, required int id}) async {
    return (await ApiServer.request(Method.delete, _buildPrefix(accountId) + '/timing/${id}')).isSuccess;
  }

  static Future<({TransactionInfoModel trans, TransactionTimingModel config})?> closeTiming(
      {required int accountId, required int id}) async {
    var response = await ApiServer.request(Method.put, _buildPrefix(accountId) + '/timing/${id}/close');
    if (!response.isSuccess) return null;

    return (
      trans: TransactionInfoModel.fromJson(response.data["Trans"]),
      config: TransactionTimingModel.fromJson(response.data["Config"]),
    );
  }

  static Future<({TransactionInfoModel trans, TransactionTimingModel config})?> openTiming(
      {required int accountId, required int id}) async {
    var response = await ApiServer.request(Method.put, _buildPrefix(accountId) + '/timing/${id}/open');
    if (!response.isSuccess) return null;
    return (
      trans: TransactionInfoModel.fromJson(response.data["Trans"]),
      config: TransactionTimingModel.fromJson(response.data["Config"]),
    );
  }
}
