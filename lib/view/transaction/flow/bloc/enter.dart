import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:meta/meta.dart';

part 'flow_list_bloc.dart';
part 'flow_list_event.dart';
part 'flow_list_state.dart';
part 'flow_condition_cubit.dart';
part 'flow_condition_state.dart';
