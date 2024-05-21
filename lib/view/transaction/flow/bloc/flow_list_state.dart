part of 'enter.dart';

@immutable
sealed class FlowListState {}

final class FlowListLoading extends FlowListState {}

final class FlowListLoaded extends FlowListState {
  FlowListLoaded();
}

final class FlowListMoreDataFetched extends FlowListState {
  FlowListMoreDataFetched();
}

final class FlowListTotalDataFetched extends FlowListState {
  FlowListTotalDataFetched();
}

final class FlowLisMoreDataFetchingEvent extends FlowListState {
  FlowLisMoreDataFetchingEvent();
}
