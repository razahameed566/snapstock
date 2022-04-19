import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class appBarMain extends StatelessWidget {
  const appBarMain(BuildContext context, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SvgPicture.asset(
        "assets/SnapStock_Horizontal.svg",
        height: 40,
      ),
      elevation: 0.0,
      centerTitle: false,
    );
  }

  // @override
  // Size get preferredSize => const Size.fromHeight(50);
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}
