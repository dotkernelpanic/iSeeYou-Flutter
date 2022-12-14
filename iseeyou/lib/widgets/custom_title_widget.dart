import 'package:flutter/material.dart';
import 'package:iseeyou/utils/universal_variables.dart';

class CustomTitle extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? icon;
  final Widget subtitle;
  final Widget? trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  CustomTitle({
    Key? key,
    required this.leading,
    required this.title,
    this.icon,
    required this.subtitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.mini = true,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        margin: margin,
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini ? 10 : 15),
                padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: UniversalVariables.greyColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          title,
                          SizedBox(height: mini ? 3 : 10),
                          Row(
                            children: <Widget>[
                              icon ?? Container(),
                              icon != null ? SizedBox(width: 5) : Container(),
                              subtitle,
                            ],
                          ),
                        ],
                      ),
                    ),
                    trailing ?? Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
