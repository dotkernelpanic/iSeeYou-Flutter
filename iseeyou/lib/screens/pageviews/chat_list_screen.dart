import 'package:flutter/material.dart';
import 'package:iseeyou/backend/resources/firebase_auth_repository.dart';
import 'package:iseeyou/utils/universal_variables.dart';
import 'package:iseeyou/widgets/chat_list_container.dart';
import 'package:iseeyou/widgets/new_chat_button.dart';

import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/user_circle_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

//Global Variables
final FirebaseAuthRepository _repository = FirebaseAuthRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  String? currentUserID;
  String? userInitials;

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUserID = user.uid;
        userInitials = Utils.getInitials(user.displayName!);
      });
    });
  }

  CustomApplicationBar customApplicationBar(BuildContext context) {
    return CustomApplicationBar(
      leading: IconButton(
        // ignore: prefer_const_constructors
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: UserCircle(userInitials),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "search_screen");
          },
        ),
        IconButton(
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customApplicationBar(context),
      floatingActionButton: StartANewChatButton(),
      body: ChatListContainer(currentUserID!),
    );
  }
}
