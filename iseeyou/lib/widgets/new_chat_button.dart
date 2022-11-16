import 'package:flutter/material.dart';
import 'package:iseeyou/utils/universal_variables.dart';

class StartANewChatButton extends StatelessWidget {
  const StartANewChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.all(15),
      child: const Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
    );
  }
}
