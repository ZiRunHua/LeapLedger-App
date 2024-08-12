import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:keepaccount_app/bloc/transaction/category/transaction_category_bloc.dart';

import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';

part 'transaction_category_tree_event.dart';
part 'transaction_category_tree_state.dart';

class CategoryData {
  TransactionCategoryFatherModel father;
  final List<TransactionCategoryModel> children;
  CategoryData(this.father, this.children);
}

class TransactionCategoryTreeBloc extends Bloc<TransactionCategoryTreeEvent, TransactionCategoryTreeState> {
  final CategoryBloc parentBloc;
  late List<CategoryData> _list;
  List<CategoryData> get list => _list;
  final AccountDetailModel account;
  final IncomeExpense type;
  late final StreamSubscription parentBlocSubscription;
  bool get canEdit => account.isCreator;
  TransactionCategoryTreeBloc({required this.account, required this.parentBloc, required this.type})
      : super(LoadingState()) {
    parentBlocSubscription = parentBloc.stream.listen(_praentBlocListen);
    on<LoadEvent>(_getTree);
    on<MoveChildEvent>(_moveChild);
    on<MoveFatherEvent>(_moveFather);
    on<DeleteChildEvent>(_deleteChild);
    on<DeleteFatherEvent>(_deleteFather);
  }
  _praentBlocListen(CategoryState state) {
    if (state is! CategoryOfAccountState || state.account.id != account.id) {
      return;
    }
    if (state is CategoryTreeLoadedState) {
      if (state.current(account: account, cond: CategoryQueryCond(type: type))) {
        _list = state.tree.map((entry) => CategoryData(entry.key, entry.value)).toList();
        this.add(LoadEvent(refresh: false));
      }
    }
  }

  @override
  Future<void> close() async {
    parentBlocSubscription.cancel();
    await super.close();
  }

  _getTree(LoadEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (event.refresh) {
      emit(LoadingState());
      parentBloc.add(CategoryTreeLoadEvent(account, cond: CategoryQueryCond(type: type)));
      return;
    }
    emit(LoadedState(_list));
  }

  _moveChild(MoveChildEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    CategoryData category = _list[event.newFatherIndex];
    final int? previousId, parentId;
    if (event.newChildIndex >= 1) {
      previousId = category.children[event.newChildIndex - 1].id;
      parentId = null;
    } else {
      previousId = null;
      parentId = category.father.id;
    }
    parentBloc.add(CategoryMoveEvent(
      account,
      categoryId: _list[event.oldFatherIndex].children[event.oldChildIndex].id,
      previousId: previousId,
      parentId: parentId,
    ));
    // update list
    TransactionCategoryModel movedItem = _list[event.oldFatherIndex].children.removeAt(event.oldChildIndex);
    movedItem.fatherId = category.father.id;
    category.children.insert(event.newChildIndex, movedItem);
    emit(LoadedState(_list));
  }

  _moveFather(MoveFatherEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    final CategoryData movedItem = _list.removeAt(event.oldFatherIndex);
    final int? previousId;
    if (event.newFatherIndex >= 1) {
      previousId = _list[event.newFatherIndex - 1].father.id;
    } else {
      previousId = null;
    }
    parentBloc.add(CategoryParentMoveEvent(
      account,
      parentId: movedItem.father.id,
      previousId: previousId,
    ));
    // update list
    _list.insert(event.newFatherIndex, movedItem);
    emit(LoadedState(_list));
  }

  _deleteChild(DeleteChildEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    parentBloc.add(CategoryDeleteEvent(account, categoryId: event.id));
  }

  _deleteFather(DeleteFatherEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    parentBloc.add(CategoryParentDeleteEvent(account, parentId: event.id));
  }
}
