import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/category/model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(TransactionCategoryInitial()) {
    on<CategoryListLoadEvent>(_loadList);
    on<CategoryTreeLoadEvent>(_loadTree);
    on<CategorySaveEvent>(_save);
    on<CategoryDeleteEvent>(_delete);
    on<CategoryMoveEvent>(_move);
    on<CategoryParentSaveEvent>(_saveParent);
    on<CategoryParentDeleteEvent>(_deleteParent);
    on<CategoryParentMoveEvent>(_moveParent);
  }

  _loadList(CategoryListLoadEvent event, Emitter<CategoryState> emit) async {
    var list = await CategoryApi.getListByCond(accountId: event.account.id, cond: event.cond);
    emit(CategoryListLoadedState(event.account, cond: event.cond, list: list));
  }

  _loadTree(CategoryTreeLoadEvent event, Emitter<CategoryState> emit) async {
    var listTree = await ApiServer.getData(
      () => CategoryApi.getTreeByCond(accountId: event.account.id, cond: event.cond),
      CategoryApi.dataFormatFunc.getTreeDataToList,
    );
    emit(CategoryTreeLoadedState(event.account, cond: event.cond, tree: listTree));
  }

  _loadAfterEdit(
    Emitter<CategoryState> emit, {
    required AccountDetailModel account,
    TransactionCategoryModel? category,
    TransactionCategoryFatherModel? parent,
  }) async {
    List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> listTree = await ApiServer.getData(
      () => CategoryApi.getTreeByCond(accountId: account.id, cond: CategoryQueryCond()),
      CategoryApi.dataFormatFunc.getTreeDataToList,
    );

    List<TransactionCategoryModel> list = [];
    for (var childTree in listTree) list.addAll(childTree.value);

    emit(CategoryTreeLoadedState(account, cond: CategoryQueryCond(), tree: listTree));
    emit(CategoryListLoadedState(account, cond: CategoryQueryCond(), list: list));

    // emit state by cond
    late CategoryQueryCond cond;
    if (category == null && parent == null) {
      cond = CategoryQueryCond();
    } else {
      assert(category == null || parent == null || category.incomeExpense == parent.incomeExpense);
      if (category != null) cond = CategoryQueryCond(type: category.incomeExpense);
      if (parent != null) cond = CategoryQueryCond(type: parent.incomeExpense);
    }
    var emitState = (IncomeExpense ie) {
      emit(CategoryTreeLoadedState(
        account,
        cond: CategoryQueryCond(type: ie),
        tree: listTree.where((element) => element.key.incomeExpense == ie).toList(),
      ));
      emit(CategoryListLoadedState(
        account,
        cond: CategoryQueryCond(type: ie),
        list: list.where((element) => element.incomeExpense == ie).toList(),
      ));
    };
    if (cond.type != null) {
      emitState(cond.type!);
    } else {
      emitState(IncomeExpense.expense);
      emitState(IncomeExpense.income);
    }
  }

  _save(CategorySaveEvent event, Emitter<CategoryState> emit) async {
    TransactionCategoryModel? category = event.category;
    category.accountId = event.account.id;
    if (event.category.isValid) {
      category = await CategoryApi.updateCategory(category);
    } else {
      category = await CategoryApi.addCategory(category);
    }
    if (category != null) {
      emit(SaveSuccessState(event.account, category: category));
    } else {
      emit(SaveFailState(event.account, category: event.category));
    }
    await _loadAfterEdit(emit, account: event.account, category: category);
  }

  _delete(CategoryDeleteEvent event, Emitter<CategoryState> emit) async {
    var response = await CategoryApi.deleteCategory(event.categoryId, accountId: event.account.id);
    if (false == response.isSuccess) {
      emit(DeleteFailState(event.account, categoryId: event.categoryId));
      return;
    }
    emit(DeleteSuccessState(event.account, categoryId: event.categoryId));
    await _loadAfterEdit(emit, account: event.account);
  }

  _move(CategoryMoveEvent event, Emitter<CategoryState> emit) async {
    var response = await CategoryApi.moveCategory(
      event.categoryId,
      accountId: event.account.id,
      previous: event.previousId,
      parentId: event.parentId,
    );
    if (false == response.isSuccess) {
      emit(CategoryMoveFailState(event.account, categoryId: event.categoryId, previousId: event.previousId));
      return;
    }
    emit(CategoryMoveSuccessState(event.account, categoryId: event.categoryId, previousId: event.previousId));
    await _loadAfterEdit(emit, account: event.account);
  }

  _saveParent(CategoryParentSaveEvent event, Emitter<CategoryState> emit) async {
    TransactionCategoryFatherModel? parent = event.parent;
    parent.accountId = event.account.id;
    if (event.parent.isValid) {
      parent = await CategoryApi.updateCategoryParent(parent);
    } else {
      parent = await CategoryApi.addCategoryParent(parent);
    }
    if (parent == null) {
      emit(CategoryParentSaveFailState(event.account, parent: event.parent));
      return;
    }
    emit(CategoryParentSaveSuccessState(event.account, parent: parent));
    await _loadAfterEdit(emit, account: event.account, parent: parent);
  }

  _deleteParent(CategoryParentDeleteEvent event, Emitter<CategoryState> emit) async {
    var response = await CategoryApi.deleteCategoryParent(event.parentId, accountId: event.account.id);
    if (false == response.isSuccess) {
      emit(CategoryParentDeleteFailState(event.account, parentId: event.parentId));
      return;
    }
    emit(CategoryParentDeleteSuccessState(event.account, parentId: event.parentId));
    await _loadAfterEdit(emit, account: event.account);
  }

  _moveParent(CategoryParentMoveEvent event, Emitter<CategoryState> emit) async {
    var response = await CategoryApi.moveCategoryParent(
      event.parentId,
      accountId: event.account.id,
      previous: event.previousId,
    );
    if (false == response.isSuccess) {
      emit(CategoryParentMoveFailState(event.account, parentId: event.parentId, previousId: event.previousId));
      return;
    }
    emit(CategoryParentMoveSuccessState(event.account, parentId: event.parentId, previousId: event.previousId));
    await _loadAfterEdit(emit, account: event.account);
  }
}
