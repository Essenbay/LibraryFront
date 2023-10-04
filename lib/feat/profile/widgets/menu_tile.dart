import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    this.icon,
    required this.text,
    this.subText,
    this.titleWeigh = FontWeight.w500,
    required this.onClick,
  });
  final Widget? icon;
  final String text;
  final FontWeight titleWeigh;
  final String? subText;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {onClick()},
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null)
                  SizedBox(
                    width: 20,
                    child: icon,
                  ),
                if (icon != null) const SizedBox(width: 15),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    text,
                    style: TextStyle(
                        fontWeight: titleWeigh,
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  if (subText != null)
                    Text(subText ?? '',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14)),
                ]),
              ],
            ),
            IconButton(
                onPressed: () => onClick(),
                icon: const Icon(
                  CupertinoIcons.chevron_right,
                  color: Colors.black,
                ))
          ],
        ),
      ),
    );
  }
}
