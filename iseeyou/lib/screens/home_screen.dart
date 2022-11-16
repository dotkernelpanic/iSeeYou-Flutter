import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iseeyou/utils/universal_variables.dart';

import 'pageviews/chat_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void onPageChangedCallback(int page) {
    setState(() {
      this._page = page;
    });
  }

  void navTappedCallback(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChangedCallback,
        children: <Widget>[
          Container(
            child: ChatListScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: UniversalVariables.blackColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.chat,
                    color: (_page == 0)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call,
                    color: (_page == 1)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone,
                    color: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                label: "Chats",
              ),
            ],
            onTap: navTappedCallback,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
