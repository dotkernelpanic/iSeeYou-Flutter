import 'package:flutter/material.dart';

import '../utils/universal_variables.dart';
import 'custom_title_widget.dart';

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  ChatListContainer(this.currentUserId);

  @override
  State<ChatListContainer> createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTitle(
            mini: false,
            onTap: () {},
            title: Text(
              "User Name",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Arial",
                fontSize: 19,
              ),
            ),
            subtitle: Text(
              "This is the last message",
              style: TextStyle(
                color: UniversalVariables.greyColor,
                fontSize: 14,
              ),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: UniversalVariables.onlineDotColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: UniversalVariables.blackColor,
                          width: 2,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
