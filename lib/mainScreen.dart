import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/photographers.dart';
import 'package:flutter_application_1/upload.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_collage_widget/utils/CollageType.dart';

import 'Chat/chatroomscreen.dart';
import 'Explore.dart';
import 'home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}

class MyState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _bottomNavBarIndex = 0;
  late TabController _tabController;

  void _tabUpdate() {
    setState(() {
      _bottomNavBarIndex = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_tabUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _tabController.removeListener(_tabUpdate);
  }

  @override
  Widget build(BuildContext context) {
    var value = 0xffF1941F;
    var color = const Color(0xff787878);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            // shrinkWrap: true,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(padding: EdgeInsets.fromLTRB(5, 2, 5, 2)),
                    SvgPicture.asset(
                      'assets/SnapStock_Horizontal.svg',
                      height: 41,
                      width: 41,
                    ),
                    const Icon(
                      Icons.account_circle,
                      size: 41,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1000,
                child: TabBarView(controller: _tabController, children: [
                  HomeTab(),
                  const ExploreTab(),
                  UploadTab(),
                  const PhotographersTab(),
                  const ChatRoomScreen(),
                ]),
              ),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(
              icon: Icon(Icons.home_filled),
              text: "Home",
              iconMargin: EdgeInsets.only(bottom: 3.0),
            ),
            const Tab(
              icon: Icon(Icons.explore),
              text: "Explore",
              iconMargin: EdgeInsets.only(bottom: 3.0),
            ),
            GestureDetector(
              onTap: () => UploadTab(),
              child: const Tab(
                icon: Icon(Icons.upload),
                text: "Upload",
                iconMargin: EdgeInsets.only(bottom: 3.0),
              ),
            ),
            const Tab(
              icon: Icon(Icons.camera_enhance),
              text: "Photographers",
              iconMargin: EdgeInsets.only(bottom: 3.0),
            ),
            const Tab(
              icon: Icon(Icons.chat),
              text: "Chat",
              iconMargin: EdgeInsets.only(bottom: 3.0),
            ),
          ],
          labelColor: Color(value),
          unselectedLabelColor: color,
        ),
      ),
    );
  }
}
