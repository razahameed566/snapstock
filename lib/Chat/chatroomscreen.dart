import 'package:flutter/material.dart';
import 'package:flutter_application_1/Chat/searchChat.dart';
import 'package:flutter_application_1/helper/constants.dart';
import 'package:flutter_application_1/helper/helper.dart';
import 'package:flutter_application_1/services/auth.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoomScreen> {
  AuthService authService = new AuthService();

  @override
  void initState() {
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffF1941F),
          foregroundColor: Colors.white,
          child: const Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchChat()));
          }),
    );
  }
}
