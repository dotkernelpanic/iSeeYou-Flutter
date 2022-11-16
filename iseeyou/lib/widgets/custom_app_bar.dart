import 'package:flutter/material.dart';
import 'package:iseeyou/utils/universal_variables.dart';

class CustomApplicationBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomApplicationBar({
    Key? key,
    required this.title,
    required this.actions,
    required this.leading,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: UniversalVariables.blackColor,
        border: Border(
          bottom: BorderSide(
            color: UniversalVariables.separatorColor,
            width: 1.6,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        elevation: 0,
        title: title,
        centerTitle: centerTitle,
        leading: leading,
        actions: actions,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
