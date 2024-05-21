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
    Future<void> incomeFunc() async {
      List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> expenseTree =
          await ApiServer.getData(
        () => TransactionCategoryApi.getTree(accountId: account.id, type: IncomeExpense.expense),
        TransactionCategoryApi.dataFormatFunc.getTreeDataToList,
      );
      _tree.addAll(expenseTree);
    }

    Future<void> expenseFunc() async {
      List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> incomeTree =
          await ApiServer.getData(
        () => TransactionCategoryApi.getTree(accountId: account.id, type: IncomeExpense.income),
        TransactionCategoryApi.dataFormatFunc.getTreeDataToList,
      );
      _tree.addAll(incomeTree);
    }

    late ResponseBody responseBody;
    Future<void> getProduct() async => responseBody = await ProductApi.getList();

    await Future.wait<void>([incomeFunc(), expenseFunc(), getProduct()]);
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
