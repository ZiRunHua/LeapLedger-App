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

  void _onFetchMoreData() {}
  Future<void> _onRefresh() async {
    currentState = PageStatus.moreDataFetching;
  }

  late final ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _buildInput(),
          actions: [TextButton(onPressed: _onSubmitSearch, child: const Text("查找"))],
        ),
        body: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserFriendLoaded) {
                _initData(state.list);
              } else if (state is UserSearchFinish) {
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

  void _initData(List<UserInfoModel> data) {
    setState(() {
      displayContent = data;
      searchResult = data;
      currentState = PageStatus.loaded;
    });
  }

  List<UserInfoModel> searchResult = [];
  List<UserInfoModel> displayContent = [];
  Widget _buildList() {
    if (currentState == PageStatus.loading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // 构建子集
          return _buildListTile(displayContent[index]);
        },
        childCount: displayContent.length, // 子集的数量
      ),
    );
  }

  Widget _buildListTile(UserInfoModel user) {
    return ListTile(
      title: Text(user.username),
      subtitle: Text(user.email),
      onTap: () => _onSelectUser(user),
    );
  }

  Widget _buildInput() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(Constant.padding),
        child: FormInputField.searchInput(onChanged: _onChange),
      ),
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
    Navigator.pop<UserInfoModel>(context, user);
  }

  void _onSubmitSearch() {
    if (inputStr == null) {
      CommonToast.tipToast("请输入搜索内容");
    }
    UserBloc.of(context).add(UserSearchEvent(inputStr!));
  }
}
