part of 'category_bloc.dart';

abstract class CategoryEvent {}

abstract class CategoryOfAccountEvent extends CategoryEvent {
  final AccountDetailModel account;
  CategoryOfAccountEvent(this.account);
}

class CategoryListLoadEvent extends CategoryOfAccountEvent {
  final CategoryQueryCond cond;
  CategoryListLoadEvent(super.account, {required this.cond});
}

class CategoryTreeLoadEvent extends CategoryOfAccountEvent {
  final CategoryQueryCond cond;
  CategoryTreeLoadEvent(super.account, {required this.cond});
}

class CategorySaveEvent extends CategoryOfAccountEvent {
  final TransactionCategoryModel category;
  CategorySaveEvent(super.account, {required this.category});
}

class CategoryDeleteEvent extends CategoryOfAccountEvent {
  final int categoryId;
  CategoryDeleteEvent(super.account, {required this.categoryId});
}

class CategoryMoveEvent extends CategoryOfAccountEvent {
  final int categoryId;
  final int? previousId, parentId;
  CategoryMoveEvent(super.account, {required this.categoryId, this.previousId, this.parentId});
}

class CategoryParentSaveEvent extends CategoryOfAccountEvent {
  final TransactionCategoryFatherModel parent;
  CategoryParentSaveEvent(super.account, {required this.parent});
}

class CategoryParentDeleteEvent extends CategoryOfAccountEvent {
  final int parentId;
  CategoryParentDeleteEvent(super.account, {required this.parentId});
}

class CategoryParentMoveEvent extends CategoryOfAccountEvent {
  final int parentId;
  final int? previousId;
  CategoryParentMoveEvent(super.account, {required this.parentId, this.previousId});
}
