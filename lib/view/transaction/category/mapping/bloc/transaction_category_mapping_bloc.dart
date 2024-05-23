import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:keepaccount_app/model/product/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:meta/meta.dart';

part 'transaction_category_mapping_event.dart';
part 'transaction_category_mapping_state.dart';

abstract class TransactionCategoryMappingBloc<T>
    extends Bloc<TransactionCategoryMappingEvent, TransactionCategoryMappingState> {
  TransactionCategoryMappingBloc(
      {required this.account,
      List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? parentCategoryTree,
      this.childCategoryList})
      : super(TransactionCategoryMappingInitial()) {
    this.parentCategoryTree = parentCategoryTree;
    on<TransactionCategoryMappingLoadEvent>(load);
    on<TransactionCategoryMappingAddEvent>(
        (TransactionCategoryMappingAddEvent event, Emitter<TransactionCategoryMappingState> emit) async {
      if (!canEdit) return;
      await mapping(event, emit);
    });
    on<TransactionCategoryMappingDeleteEvent>(
        (TransactionCategoryMappingDeleteEvent event, Emitter<TransactionCategoryMappingState> emit) async {
      if (!canEdit) return;
      await deleteMapping(event, emit);
    });
  }

  List<BaseTransactionCategoryModel> unmapped = [];

  late List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? _parentCategoryTree;
  late List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> expenseCategoryTree;
  late List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> incomeCategoryTree;
  List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? get parentCategoryTree =>
      _parentCategoryTree;
  set parentCategoryTree(List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? value) {
    _parentCategoryTree = value;
    if (_parentCategoryTree == null || _parentCategoryTree!.isEmpty) {
      incomeCategoryTree = [];
      expenseCategoryTree = [];
    } else {
      incomeCategoryTree =
          _parentCategoryTree!.where((element) => element.key.incomeExpense == IncomeExpense.income).toList();
      expenseCategoryTree =
          _parentCategoryTree!.where((element) => element.key.incomeExpense == IncomeExpense.expense).toList();
    }
  }

  final AccountDetailModel account;
  late List<T>? childCategoryList;
  bool get canEdit => !account.isReader;

  load(TransactionCategoryMappingLoadEvent event, Emitter<TransactionCategoryMappingState> emit);
  mapping(TransactionCategoryMappingAddEvent event, Emitter<TransactionCategoryMappingState> emit);
  deleteMapping(TransactionCategoryMappingDeleteEvent event, Emitter<TransactionCategoryMappingState> emit);
  getList() async {}
}

class AccountTransactionCategoryMappingBloc extends TransactionCategoryMappingBloc<TransactionCategoryModel> {
  final AccountDetailModel childAccount;
  AccountDetailModel get parentAccount => super.account;
  Map<int, List<BaseTransactionCategoryModel>> relation = {};

  AccountTransactionCategoryMappingBloc(
      {required this.childAccount,
      required AccountDetailModel parentAccount,
      List<TransactionCategoryModel>? childCategoryList,
      List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? parentCategoryTree})
      : super(account: parentAccount, childCategoryList: childCategoryList, parentCategoryTree: parentCategoryTree);

  @override
  load(TransactionCategoryMappingLoadEvent event, Emitter<TransactionCategoryMappingState> emit) async {
    // 获取
    List<TransactionCategoryMappingTreeNodeApiModel> tree = [];
    List<Future<void>> waitGroup = [
      Future<void>(() async => tree = await TransactionCategoryApi.getCategoryMappingTree(
          parentAccountId: parentAccount.id, childAccountId: childAccount.id))
    ];
    if (childCategoryList == null) waitGroup.add(getList());
    if (parentCategoryTree == null) waitGroup.add(getParentCategoryTree());
    await Future.wait(waitGroup);
    // 处理
    Map<int, BaseTransactionCategoryModel> unmappedMap = {};
    for (BaseTransactionCategoryModel item in childCategoryList!) {
      unmappedMap[item.id] = item;
    }
    if (tree.isNotEmpty) {
      for (var father in tree) {
        List<BaseTransactionCategoryModel> child = [];
        for (var childId in father.childrenIds) {
          if (unmappedMap[childId] != null) {
            child.add(unmappedMap[childId]!);
            unmappedMap.remove(childId);
          }
        }
        relation[father.fatherId] = child;
      }
    }
    unmapped = unmappedMap.values.toList();
    _emitLoaded(emit);
  }

  getParentCategoryTree() async => parentCategoryTree = await ApiServer.getData(
        () => TransactionCategoryApi.getTree(accountId: parentAccount.id),
        TransactionCategoryApi.dataFormatFunc.getTreeDataToList,
      );

  @override
  getList() async => childCategoryList = await ApiServer.getData(
        () => TransactionCategoryApi.getTree(accountId: childAccount.id),
        TransactionCategoryApi.dataFormatFunc.getCategoryListByTree,
      );

  @override
  mapping(TransactionCategoryMappingAddEvent event, Emitter<TransactionCategoryMappingState> emit) async {
    bool isSuccess = await TransactionCategoryApi.mappingCategory(parentId: event.parent.id, childId: event.child.id);
    if (isSuccess) {
      if (relation[event.parent.id] != null) {
        relation[event.parent.id]?.add(event.child);
      } else {
        relation[event.parent.id] = [event.child];
      }
      unmapped.removeWhere((element) => event.child.id == element.id);

      _emitLoaded(emit, type: event.parent.incomeExpense);
    }
  }

  @override
  deleteMapping(TransactionCategoryMappingDeleteEvent event, Emitter<TransactionCategoryMappingState> emit) async {
    bool isSuccess =
        await TransactionCategoryApi.deleteCategoryMapping(parentId: event.parent.id, childId: event.child.id);
    if (isSuccess) {
      if (relation[event.parent.id] != null) {
        relation[event.parent.id]?.removeWhere((element) => event.child.id == element.id);
      } else {
        relation[event.parent.id] = [event.child];
      }
      unmapped.add(event.child);
      _emitLoaded(emit, type: event.parent.incomeExpense);
    }
  }

  _emitLoaded(Emitter<TransactionCategoryMappingState> emit, {IncomeExpense? type}) {
    if (type == null || type == IncomeExpense.expense) {
      var emitUnmapped = unmapped.where((element) => element.incomeExpense == IncomeExpense.expense).toList();

      emit(TransactionCategoryMappingExpenseLoaded(emitUnmapped, relation));
    }
    if (type == null || type == IncomeExpense.income) {
      var emitUnmapped = unmapped.where((element) => element.incomeExpense == IncomeExpense.income).toList();

      emit(TransactionCategoryMappingIncomeLoaded(emitUnmapped, relation));
    }
  }
}

class ProductTransactionCategoryMappingBloc extends TransactionCategoryMappingBloc<ProductTransactionCategoryModel> {
  ProductTransactionCategoryMappingBloc({
    required this.product,
    required AccountDetailModel account,
    List<ProductTransactionCategoryModel>? list,
    List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? categoryTree,
  }) : super(account: account, childCategoryList: list, parentCategoryTree: categoryTree);

  final ProductModel product;
  //交易类型id与产品交易类型关联
  Map<int, List<BaseTransactionCategoryModel>> relation = {};

  @override
  load(TransactionCategoryMappingLoadEvent event, Emitter<TransactionCategoryMappingState> emit) async {
    ResponseBody treeResponse = await ProductApi.getCategorymappingTree(product.uniqueKey);
    if (childCategoryList == null) {
      await getList();
    }
    if (treeResponse.isSuccess) {
      Map<int, BaseTransactionCategoryModel> unmappedMap = {};
      for (BaseTransactionCategoryModel ptc in childCategoryList!) {
        unmappedMap[ptc.id] = ptc;
      }
      relation = {};
      List<BaseTransactionCategoryModel> child;
      if (treeResponse.data['Tree'] != null) {
        for (Map<String, dynamic> data in treeResponse.data['Tree']) {
          child = [];
          if (data['Children'] != null) {
            for (int childId in data['Children']) {
              if (unmappedMap[childId] != null) {
                child.add(unmappedMap[childId]!);
                unmappedMap.remove(childId);
              }
            }
          }
          relation[data['FatherId']] = child;
        }
      }
      unmapped = unmappedMap.values.toList();
      _emitLoaded(emit);
    }
  }

  @override
  getList() async {
    ResponseBody responseBody = await ProductApi.getTransactionCategory(product.uniqueKey);
    childCategoryList = [];
    if (responseBody.isSuccess) {
      for (Map<String, dynamic> data in responseBody.data['List']) {
        childCategoryList!.add(ProductTransactionCategoryModel.fromJson(data));
      }
    }
  }

  @override
  mapping(TransactionCategoryMappingAddEvent event, Emitter<TransactionCategoryMappingState> emit) async {
    ResponseBody responseBody = await ProductApi.mappingTransactionCategory(event.parent, event.child.id);
    if (responseBody.isSuccess) {
      if (relation[event.parent.id] != null) {
        relation[event.parent.id]?.add(event.child);
      } else {
        relation[event.parent.id] = [event.child];
      }
      unmapped.removeWhere((element) => event.child.id == element.id);

      _emitLoaded(emit, type: event.parent.incomeExpense);
    }
  }

  @override
  deleteMapping(TransactionCategoryMappingDeleteEvent event, Emitter<TransactionCategoryMappingState> emit) async {
    ResponseBody responseBody = await ProductApi.deleteTransactionCategoryMapping(event.parent, event.child.id);
    if (responseBody.isSuccess) {
      if (relation[event.parent.id] != null) {
        relation[event.parent.id]?.removeWhere((element) => event.child.id == element.id);
      } else {
        relation[event.parent.id] = [event.child];
      }
      unmapped.add(event.child);
      _emitLoaded(emit, type: event.parent.incomeExpense);
    }
  }

  _emitLoaded(Emitter<TransactionCategoryMappingState> emit, {IncomeExpense? type}) {
    if (type == null || type == IncomeExpense.expense) {
      var emitUnmapped = unmapped.where((element) => element.incomeExpense == IncomeExpense.expense).toList();

      emit(TransactionCategoryMappingExpenseLoaded(emitUnmapped, relation));
    }
    if (type == null || type == IncomeExpense.income) {
      var emitUnmapped = unmapped.where((element) => element.incomeExpense == IncomeExpense.income).toList();

      emit(TransactionCategoryMappingIncomeLoaded(emitUnmapped, relation));
    }
  }
}
