// import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Chat/conversations_screen.dart';
import 'package:flutter_application_1/helper/constants.dart';
import 'package:flutter_application_1/services/database.dart';
// import 'package:flutter_application_1/widget.dart';

class SearchChat extends StatefulWidget {
  const SearchChat({Key? key}) : super(key: key);

  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();
  bool isLoading = false;
  bool haveUserSearched = false;
  late QuerySnapshot searchSnapshot;

  initiateSearch() async {
    if (searchTextEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchTextEditingController.text)
          .then((snapshot) {
        searchSnapshot = snapshot;
        print("$searchSnapshot");

        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget searchList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                searchSnapshot.docs[index].get("userName"),
                searchSnapshot.docs[index].get("userEmail"),
                userEmail: '',
                userName: '',
              );
            })
        : Container();

    // return searchSnapshot != null
    //     ? ListView.builder(itemBuilder: ((context, index) {
    //         itemCount:
    //         searchSnapshot.docs.length;
    //         return const SearchTile(userEmail: "", userName: "userName");
    //       }))
    //     : Container();
  }

  /// create chatRoom, send user to conversation screen, push replacement

  conversation(String userName) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);
    List<String> users = [];
    databaseMethods.addChatRoom(userName, Constants.myName);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };
    databaseMethods.addChatRoom(chatRoomMap, chatRoomId);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConversationScreen()));

    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget SearchTile(param0, param1,
      {required String userName, required String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName),
              Text(userEmail),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              conversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text("Message"),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xffFCFCFC),
        foregroundColor: const Color(0xffF1941F),
        title: const Text("Conversations"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchTextEditingController,
                    decoration: const InputDecoration(
                      hintText: "search username...",
                      hintStyle: TextStyle(color: Color(0xff787878)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color(0x36787787),
                          Color(0x36787787),
                        ]),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset('assets/search_white.png')),
                ),
              ],
            ),
          ),
          searchList()
        ],
      ),
    );
  }
}
