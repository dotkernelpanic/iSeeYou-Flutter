import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iseeyou/backend/resources/firebase_auth_repository.dart';
import 'package:iseeyou/models/user_model.dart';
import 'package:iseeyou/screens/pageviews/chat_list_screen.dart';
import 'package:iseeyou/utils/universal_variables.dart';
import 'package:iseeyou/widgets/custom_title_widget.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import 'chatscreens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseAuthRepository _repository = FirebaseAuthRepository();

  List<GoogleUser> userList = [];
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user) {
      _repository.fetchAllUsers(user).then((List<GoogleUser> list) {
        setState(() {
          userList = list;
        });
      });
      for (int i = 0; i < userList.length; i++) {
        print(
            "userList[i].name: ${userList[i].name}, userList[i].uid: ${userList[i].uid}");
      }
    });
  }

  searchAppBar(BuildContext context) {
    return NewGradientAppBar(
      gradient: LinearGradient(
        colors: [
          UniversalVariables.gradientColorStart,
          UniversalVariables.gradientColorEnd
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88FFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  viewSuggestions(String query) {
    final List<GoogleUser> suggestionList = query.isEmpty
        ? []
        : userList.where((GoogleUser user) {
            String? _getUsername = user.username?.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name!.toLowerCase();
            bool? matchesUsername = _getUsername?.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername! || matchesName);
          }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        GoogleUser searchedUser = GoogleUser(
          uid: suggestionList[index].uid,
          imageUrl: suggestionList[index].imageUrl,
          name: suggestionList[index].name,
          username: suggestionList[index].username,
        );
        print(
            "searchedUser: ${searchedUser.name}, receiverID: ${searchedUser.uid}, id?: ${suggestionList[index].uid}");
        return CustomTitle(
          mini: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiver: searchedUser,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.imageUrl!),
          ),
          title: Text(searchedUser.username!),
          subtitle: Text(searchedUser.name!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: viewSuggestions(query),
      ),
    );
  }
}
