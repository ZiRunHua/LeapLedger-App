part of 'enter.dart';

sealed class ImportState {}

final class ImportInitial extends ImportState {}

final class PtcDataLoad extends ImportState {
  PtcDataLoad();
}

final class Importing extends ImportState {}

final class TransactionCreateFail extends Importing {
  final TransactionInfoModel trans;
  final String id;
  TransactionCreateFail({required this.trans, required this.id});
}

final class ProgressChanged extends Importing {
  ProgressChanged();
}

final class FailTransProgressing extends Importing {
  FailTransProgressing();
}

final class FailTransProgressFinished extends Importing {
  FailTransProgressFinished();
}

final class ProgressingFailTransChanged extends Importing {
  ProgressingFailTransChanged();
}

final class ImportFinished extends ImportState {
  ImportFinished();
}
