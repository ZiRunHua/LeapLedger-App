part of 'category_bloc.dart';

abstract class CategoryState {}

class TransactionCategoryInitial extends CategoryState {}

abstract class CategoryOfAccountState extends CategoryState {
  final AccountDetailModel account;
  CategoryOfAccountState(this.account);
}
abstract class CategoryUpdatedState extends CategoryState {
  final AccountDetailModel account;
  CategoryUpdatedState(this.account);
}

class CategoryListLoadedState extends CategoryOfAccountState {
  final CategoryQueryCond cond;
  final List<TransactionCategoryModel> list;
  CategoryListLoadedState(super.account, {required this.cond, required this.list});

  bool current({required AccountDetailModel account, required CategoryQueryCond cond}) {
    return this.account.id == account.id && this.cond.isSame(cond);
  }
}

class CategoryTreeLoadedState extends CategoryOfAccountState {
  final CategoryQueryCond cond;
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> tree;
  CategoryTreeLoadedState(super.account, {required this.cond, required this.tree});

  bool current({required AccountDetailModel account, required CategoryQueryCond cond}) {
    return this.account.id == account.id && this.cond.isSame(cond);
  }
}

class SaveSuccessState extends CategoryUpdatedState {
  final TransactionCategoryModel category;
  SaveSuccessState(super.account, {required this.category});
}

class SaveFailState extends CategoryOfAccountState {
  final TransactionCategoryModel category;
  SaveFailState(super.account, {required this.category});
}

class DeleteSuccessState extends CategoryUpdatedState {
  final int categoryId;
  DeleteSuccessState(super.account, {required this.categoryId});
}

class DeleteFailState extends CategoryOfAccountState {
  final int categoryId;
  DeleteFailState(super.account, {required this.categoryId});
}

class CategoryMoveSuccessState extends CategoryOfAccountState {
  final int categoryId;
  final int? previousId;
  CategoryMoveSuccessState(super.account, {required this.categoryId, this.previousId});
}

class CategoryMoveFailState extends CategoryOfAccountState {
  final int categoryId;
  final int? previousId;
  CategoryMoveFailState(super.account, {required this.categoryId, this.previousId});
}

class CategoryParentSaveSuccessState extends CategoryUpdatedState {
  final TransactionCategoryFatherModel parent;
  CategoryParentSaveSuccessState(super.account, {required this.parent});
}

class CategoryParentSaveFailState extends CategoryOfAccountState {
  final TransactionCategoryFatherModel parent;
  CategoryParentSaveFailState(super.account, {required this.parent});
}

class CategoryParentDeleteSuccessState extends CategoryUpdatedState {
  final int parentId;
  CategoryParentDeleteSuccessState(super.account, {required this.parentId});
}

class CategoryParentDeleteFailState extends CategoryOfAccountState {
  final int parentId;
  CategoryParentDeleteFailState(super.account, {required this.parentId});
}

class CategoryParentMoveSuccessState extends CategoryOfAccountState {
  final int parentId;
  final int? previousId;
  CategoryParentMoveSuccessState(super.account, {required this.parentId, this.previousId});
}

class CategoryParentMoveFailState extends CategoryOfAccountState {
  final int parentId;
  final int? previousId;
  CategoryParentMoveFailState(super.account, {required this.parentId, this.previousId});
}
