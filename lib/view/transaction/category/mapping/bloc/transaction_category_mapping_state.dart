part of 'transaction_category_mapping_bloc.dart';

@immutable
abstract class TransactionCategoryMappingState {}

class TransactionCategoryMappingInitial extends TransactionCategoryMappingState {}

class LoadingState extends TransactionCategoryMappingState {}

abstract class TransactionCategoryMappingLoaded extends TransactionCategoryMappingState {
  List<TransactionCategoryBaseModel> get unmapped;
  Map<int, List<TransactionCategoryBaseModel>> get relation;
}

class TransactionCategoryMappingExpenseLoaded extends TransactionCategoryMappingLoaded {
  @override
  final List<TransactionCategoryBaseModel> unmapped;
  @override
  final Map<int, List<TransactionCategoryBaseModel>> relation;
  TransactionCategoryMappingExpenseLoaded(this.unmapped, this.relation);
}

class TransactionCategoryMappingIncomeLoaded extends TransactionCategoryMappingLoaded {
  @override
  final List<TransactionCategoryBaseModel> unmapped;
  @override
  final Map<int, List<TransactionCategoryBaseModel>> relation;
  TransactionCategoryMappingIncomeLoaded(this.unmapped, this.relation);
}
