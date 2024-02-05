import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cc_state.dart';

class CcCubit extends Cubit<CcState> {
  CcCubit() : super(CcInitial());
}
