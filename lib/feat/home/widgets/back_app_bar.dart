import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackIconLeadingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String? leadingText;
  final Color? foregroundColor;
  final String? title;
  const BackIconLeadingAppBar(
      {super.key,
      this.actions,
      this.elevation = 0,
      this.leadingText,
      this.foregroundColor = Colors.blue,
      this.title,
      this.leadingPadding = 16,
      this.systemUiOverlayStyle});
  final double elevation;
  final double leadingPadding;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  @override
  Size get preferredSize => const Size.fromHeight(kMinInteractiveDimension);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: elevation,
        systemOverlayStyle: systemUiOverlayStyle,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            alignment: Alignment.center,
            onPressed: () => context.router.removeLast(),
            padding: EdgeInsets.symmetric(horizontal: leadingPadding),
            child: Icon(
              Icons.arrow_back,
              color: foregroundColor,
              size: 26,
            ),
          ),
        ),
        leadingWidth: 110,
        title: Text(
          title ?? '',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: foregroundColor),
        ),
        centerTitle: true,
        actions: [...?actions, const SizedBox(width: 8)]);
  }
}
