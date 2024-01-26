import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/user/model.dart';
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
          actions: [TextButton(onPressed: () {}, child: const Text("查找"))],
        ),
        body: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserFriendLoaded) {
                setState(() {
                  displayContent = state.list;
                  searchResult = state.list;
                  currentState = PageStatus.loaded;
                });
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

        /// 获取更多 加载中
        bottomNavigationBar: Visibility(
          visible: currentState == PageStatus.moreDataFetching,
          child: Container(
            height: 64,
            alignment: Alignment.center,
            child: const CupertinoActivityIndicator(),
          ),
        ));
  }

  List<UserModel> searchResult = [];
  List<UserModel> displayContent = [];
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

  Widget _buildListTile(UserModel user) {
    return ListTile(
      title: Text(user.username),
      subtitle: Text(user.email),
    );
  }

  Widget _buildInput() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(Constant.padding),
        child: FormInputField.searchInput(onChanged: _onChaneg),
      ),
    );
  }

  String? input;
  void _onChaneg(String? value) {
    print(value);
    input = value;

    displayContent = [];
    if (value == null) {
      return;
    }
    setState(() {
      searchResult.forEach((element) {
        if (element.username.startsWith(value) || element.email.startsWith(value)) {
          displayContent.add(element);
        }
      });
    });
  }
}
