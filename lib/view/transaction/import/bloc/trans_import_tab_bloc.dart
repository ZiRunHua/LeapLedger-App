part of 'enter.dart';

class TransImportTabBloc extends Bloc<TransImportTabEvent, TransImportTabState> {
  TransImportTabBloc({required this.account}) : super(TransImportTabInitial()) {
    on<TransImportTabLoadedEvent>(loadTab);
    on<TransactionImportUploadBillEvent>(uploadFile);
  }
  final AccountDetailModel account;
  final List<ProductModel> _list = [];
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> _tree = [];
  loadTab(TransImportTabLoadedEvent event, Emitter<TransImportTabState> emit) async {
    List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> expenseTree =
        await ApiServer.getData(
      () => TransactionCategoryApi.getTree(accountId: account.id, type: IncomeExpense.expense),
      TransactionCategoryApi.dataFormatFunc.getTreeDataToList,
    );
    for (var element in expenseTree) {
      _tree.add(element);
    }
    List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> incomeTree = await ApiServer.getData(
      () => TransactionCategoryApi.getTree(accountId: account.id, type: IncomeExpense.income),
      TransactionCategoryApi.dataFormatFunc.getTreeDataToList,
    );
    for (var element in incomeTree) {
      _tree.add(element);
    }
    ResponseBody responseBody = await ProductApi.getList();
    if (responseBody.isSuccess) {
      for (Map<String, dynamic> data in responseBody.data['List']) {
        _list.add(ProductModel.fromJson(data));
      }
      emit(TransImportTabLoaded(_list, _tree));
    }
  }

  uploadFile(TransactionImportUploadBillEvent event, Emitter<TransImportTabState> emit) async {
    ResponseBody responseBody = await ProductApi.uploadBill(event.product.uniqueKey, event.filePath);
    if (responseBody.isSuccess) {}
  }
}
