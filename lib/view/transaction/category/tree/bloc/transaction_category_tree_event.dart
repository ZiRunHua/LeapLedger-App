part of 'transaction_category_tree_bloc.dart';

abstract class TransactionCategoryTreeEvent {}

class LoadEvent extends TransactionCategoryTreeEvent {
  final bool refresh;
  LoadEvent({this.refresh = true});
}

class MoveChildEvent extends TransactionCategoryTreeEvent {
  final int oldChildIndex, oldFatherIndex, newChildIndex, newFatherIndex;
  MoveChildEvent(this.oldChildIndex, this.oldFatherIndex, this.newChildIndex, this.newFatherIndex);
}

class MoveFatherEvent extends TransactionCategoryTreeEvent {
  final int oldFatherIndex, newFatherIndex;
  MoveFatherEvent(this.oldFatherIndex, this.newFatherIndex);
}

class DeleteChildEvent extends TransactionCategoryTreeEvent {
  final int id;
  DeleteChildEvent(this.id);
}

class DeleteFatherEvent extends TransactionCategoryTreeEvent {
  final int id;
  DeleteFatherEvent(this.id);
}
