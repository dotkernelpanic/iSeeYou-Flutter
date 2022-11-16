import 'package:flutter/material.dart';
import 'package:iseeyou/utils/universal_variables.dart';

class UserCircle extends StatelessWidget {
  final String? text;

  UserCircle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: UniversalVariables.separatorColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: 13,
              ),
            ),
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
          ),
        ],
      ),
    );
  }
}
