import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/user/model.dart';
import 'package:keepaccount_app/widget/common/common.dart';
import 'package:keepaccount_app/widget/form/form.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

enum PageStatus { loading, loaded, refreshing, moreDataFetching, noMoreData }

class _UserSearchState extends State<UserSearch> {
  PageStatus currentState = PageStatus.loading;
  @override
  void initState() {
    UserBloc.of(context).add(UserFriendListFetch());
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _onFetchMoreData();
      }
    });
  }

  late final ScrollController _scrollController;
  Widget _buildInputWidget() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.only(left: Constant.padding, top: Constant.padding, bottom: Constant.padding),
        child: FormInputField.searchInput(onChanged: _onChange),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: ConstantFontSize.largeHeadline),
            child: _buildInputWidget(),
          ),
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
              onTap: _onSubmitSearch,
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.only(right: Constant.padding),
                child: Text(
                  "查找",
                  style: TextStyle(fontSize: ConstantFontSize.largeHeadline),
                ),
              )),
            )
          ],
        ),
        body: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserFriendLoaded) {
                _initData(state.list);
              } else if (state is UserSearchFinish) {
                if (state.list.isEmpty) {
                  setState(() {
                    currentState = PageStatus.noMoreData;
                  });
                  return;
                }
                if (offset != 0) {
                  setState(() {
                    searchResult.addAll(state.list);
                    displayContent.addAll(state.list);

                    currentState = PageStatus.loaded;
                  });
                  return;
                }

                _initData(state.list);
              }
            },
            child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification && _scrollController.position.extentAfter == 0) {
                      _onFetchMoreData();
                    }
                    return false;
                  },
                  child: CustomScrollView(controller: _scrollController, slivers: [_buildList()]),
                ))),

        /// 获取更多中
        bottomNavigationBar: Visibility(
          visible: currentState == PageStatus.moreDataFetching,
          child: Container(
            height: 64,
            alignment: Alignment.center,
            child: const CupertinoActivityIndicator(),
          ),
        ));
  }

  List<UserInfoModel> searchResult = [];
  List<UserInfoModel> displayContent = [];
  void _initData(List<UserInfoModel> data) {
    setState(() {
      searchResult = data;
      displayContent = [];
      for (var element in data) {
        displayContent.add(element);
      }
      currentState = PageStatus.loaded;
    });
  }

  Widget _buildList() {
    if (currentState == PageStatus.loading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SliverPrototypeExtentList(
      prototypeItem: _buildListTile(UserInfoModel(email: "testtesttest@qq.com", username: "test", id: 1)),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildListTile(displayContent[index]);
        },
        childCount: displayContent.length,
      ),
    );
  }

  Widget _buildListTile(UserInfoModel user) {
    return ListTile(
      leading: user.avatarPainterWidget,
      title: Text(user.username),
      subtitle: Text(user.email),
      onTap: () => _onSelectUser(user),
    );
  }

  String? inputStr;
  void _onChange(String? value) {
    inputStr = value;
    displayContent = [];
    if (value == null) {
      return;
    }
    setState(() {
      for (var element in searchResult) {
        if (element.username.startsWith(value) || element.email.startsWith(value)) {
          displayContent.add(element);
        }
      }
    });
  }

  void _onSelectUser(UserInfoModel user) {
    print(user.id);
  }

  int offset = 0;
  int limit = 20;
  void _onSubmitSearch() {
    if (inputStr == null) {
      CommonToast.tipToast("请输入搜索用户名");
      return;
    }
    offset = 0;
    limit = 20;
    UserBloc.of(context).add(UserSearchEvent.formInputUsername(offset: offset, limit: limit, inputStr: inputStr!));
  }

  void _onFetchMoreData() {
    if (currentState == PageStatus.noMoreData || currentState == PageStatus.refreshing) {
      return;
    }

    offset += limit;
    UserBloc.of(context).add(UserSearchEvent.formInputUsername(offset: offset, limit: limit, inputStr: inputStr!));
    setState(() {
      currentState = PageStatus.moreDataFetching;
    });
  }

  Future<void> _onRefresh() async {
    if (inputStr == null) {
      return;
    }
    offset = 0;
    limit = 20;
    UserBloc.of(context).add(UserSearchEvent.formInputUsername(offset: offset, limit: limit, inputStr: inputStr!));
    setState(() {
      currentState = PageStatus.refreshing;
    });
  }
}
