import 'package:bloc/bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';

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
  late List<CategoryData> _list;
  final AccountDetailModel account;
  TransactionCategoryTreeBloc({required this.account}) : super(LoadingState()) {
    on<LoadEvent>(_getTree);
    on<MoveChildEvent>(_moveChild);
    on<MoveFatherEvent>(_moveFather);
    on<DeleteChildEvent>(_deleteChild);
    on<DeleteFatherEvent>(_deleteFather);
    on<AddChildEvent>(_addChild);
    on<AddFatherEvent>(_addFather);
    on<UpdateChildEvent>(_updateChild);
    on<UpdateFatherEvent>(_updateFather);
  }
  bool get canEdit => account.isCreator;

  _getTree(LoadEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    emit(LoadingState());

    List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> list;
    list = await ApiServer.getData(
      () => TransactionCategoryApi.getTree(accountId: account.id, type: event.incomeExpense),
      TransactionCategoryApi.dataFormatFunc.getTreeDataToList,
    );

    _list = list.map((entry) => CategoryData(entry.key, entry.value)).toList();
    emit(LoadedState(_list));
  }

  _moveChild(MoveChildEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    CategoryData category = _list[event.newFatherIndex];

    ResponseBody responseBody;
    if (event.newChildIndex >= 1) {
      responseBody = await TransactionCategoryApi.moveCategoryChild(
          _list[event.oldFatherIndex].children[event.oldChildIndex].id,
          previous: category.children[event.newChildIndex - 1].id);
    } else {
      responseBody = await TransactionCategoryApi.moveCategoryChild(
          _list[event.oldFatherIndex].children[event.oldChildIndex].id,
          fatherId: category.father.id);
    }
    if (responseBody.isSuccess) {
      TransactionCategoryModel movedItem = _list[event.oldFatherIndex].children.removeAt(event.oldChildIndex);
      movedItem.fatherId = category.father.id;
      category.children.insert(event.newChildIndex, movedItem);
      emit(LoadedState(_list));
    }
  }

  _moveFather(MoveFatherEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    ResponseBody responseBody;
    CategoryData movedItem = _list.removeAt(event.oldFatherIndex);
    if (event.newFatherIndex >= 1) {
      responseBody = await TransactionCategoryApi.moveCategoryFather(movedItem.father.id,
          previous: _list[event.newFatherIndex - 1].father.id);
    } else {
      responseBody = await TransactionCategoryApi.moveCategoryFather(movedItem.father.id);
    }
    if (responseBody.isSuccess) {
      _list.insert(event.newFatherIndex, movedItem);
      emit(LoadedState(_list));
    }
  }

  _deleteChild(DeleteChildEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    if ((await TransactionCategoryApi.deleteCategoryChild(event.id)).isSuccess) {
      for (var i = 0; i < _list.length; i++) {
        _list[i].children.removeWhere((element) => element.id == event.id);
      }
      emit(LoadedState(_list));
    }
  }

  _deleteFather(DeleteFatherEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    if ((await TransactionCategoryApi.deleteCategoryFather(event.id)).isSuccess) {
      _list.removeWhere((element) => element.father.id == event.id);
      emit(LoadedState(_list));
    }
  }

  _addChild(AddChildEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    var item = _list.firstWhere((element) => element.father.id == event.transactionCategoryModel.fatherId);

    item.children.insert(0, event.transactionCategoryModel);
    emit(LoadedState(_list));
  }

  _addFather(AddFatherEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    _list.insert(0, CategoryData(event.transactionCategoryFatherModel, []));
    emit(LoadedState(_list));
  }

  _updateChild(UpdateChildEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    _list.map((e) {
      for (int i = 0; i < e.children.length; i++) {
        if (e.children[i].id == event.transactionCategoryModel.id) {
          e.children[i] = event.transactionCategoryModel;
          break;
        }
      }
    });
    emit(LoadedState(_list));
  }

  _updateFather(UpdateFatherEvent event, Emitter<TransactionCategoryTreeState> emit) async {
    if (!canEdit) return;
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].father.id == event.transactionCategoryFatherModel.id) {
        _list[i].father = event.transactionCategoryFatherModel;
        break;
      }
    }
    emit(LoadedState(_list));
  }
}
