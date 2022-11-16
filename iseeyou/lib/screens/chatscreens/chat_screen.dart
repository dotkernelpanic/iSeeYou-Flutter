import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iseeyou/backend/resources/firebase_auth_repository.dart';
import 'package:iseeyou/models/message_model.dart';
import 'package:iseeyou/models/user_model.dart';
import 'package:iseeyou/utils/universal_variables.dart';
import 'package:iseeyou/widgets/custom_app_bar.dart';
import 'package:iseeyou/widgets/custom_title_widget.dart';

class ChatScreen extends StatefulWidget {
  final GoogleUser receiver;

  ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isWriting = false;
  TextEditingController _messageController = TextEditingController();
  FirebaseAuthRepository _repository = FirebaseAuthRepository();

  GoogleUser? sender;
  String? currentUserID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user) {
      currentUserID = user.uid;
      setState(() {
        sender = GoogleUser(
          uid: user.uid,
          imageUrl: user.photoURL,
          name: user.displayName,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(child: messageList()),
          chatControlsWidget(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("messages")
            .doc(currentUserID)
            .collection(widget.receiver.uid!)
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data!.docs[index]);
            },
          );
        });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Container(
          alignment: snapshot.get("senderID") == currentUserID
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: snapshot.get("senderID") == currentUserID
              ? senderLayout(snapshot)
              : receiverLayout(snapshot),
        ));
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = const Radius.circular(10);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(snapshot),
      ),
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = const Radius.circular(10);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getMessage(snapshot),
      ),
    );
  }

  getMessage(DocumentSnapshot snapshot) {
    return Text(
      snapshot.get("message"),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget chatControlsWidget() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: const <Widget>[
                      ModalTile(
                          title: "Media",
                          subtitle: "Share Photos and Videos",
                          icon: Icons.image),
                      ModalTile(
                          title: "File",
                          subtitle: "Share files",
                          icon: Icons.file_upload_outlined),
                      ModalTile(
                          title: "Contact",
                          subtitle: "Share your contacts",
                          icon: Icons.contacts_rounded),
                      ModalTile(
                          title: "Location",
                          subtitle: "Share your location",
                          icon: Icons.location_on_rounded),
                      ModalTile(
                          title: "Schedule Call",
                          subtitle: "Arrange a calls and get a reminder",
                          icon: Icons.schedule_rounded),
                      ModalTile(
                          title: "Create Poll",
                          subtitle: "Share polls",
                          icon: Icons.poll_rounded),
                    ],
                  ),
                )
              ],
            );
          });
    }

    return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => addMediaModal(context),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: UniversalVariables.fabGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  (value.isNotEmpty && value.trim() != "")
                      ? setWritingTo(true)
                      : setWritingTo(false);
                },
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: UniversalVariables.greyColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: UniversalVariables.separatorColor,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_rounded),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            isWriting
                ? Container()
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.record_voice_over)),
            isWriting ? Container() : const Icon(Icons.camera_alt_rounded),
            isWriting
                ? Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 15,
                        ),
                        onPressed: () => sendMessage()),
                  )
                : Container()
          ],
        ));
  }

  sendMessage() {
    var text = _messageController.text;
    _messageController.clear();
    Message _message = Message(
      receiverID: widget.receiver.uid,
      senderID: sender!.uid,
      message: text,
      timestamp: FieldValue.serverTimestamp(),
      type: 'text',
    );

    setState(() {
      isWriting = false;
    });

    _repository.addMessageToDb(_message, sender!, widget.receiver);
  }

  CustomApplicationBar customAppBar(context) {
    return CustomApplicationBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name!,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.video_call,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.phone,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;

  const ModalTile(
      {Key? key,
      @required this.title,
      @required this.subtitle,
      @required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTitle(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle!,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title!,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
