import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const DefaultAppBar({Key? key, required this.text}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      toolbarHeight: 84,
      backgroundColor:Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontFamily: 'Pacifico',
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
