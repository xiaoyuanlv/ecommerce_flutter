import 'package:ecommerce_flutter/constant.dart';
import 'package:ecommerce_flutter/services/firebase_services.dart';
import 'package:ecommerce_flutter/tabs/home_tab.dart';
import 'package:ecommerce_flutter/tabs/saved_tab.dart';
import 'package:ecommerce_flutter/tabs/search_tab.dart';
import 'package:ecommerce_flutter/widgets/bottom_tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  PageController _tabPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: PageView(
              controller: _tabPageController,
              onPageChanged: (num) {
                setState(() {
                  _selectedTab = num;
                });
              },
              children: [
                HomeTab(),
                SearchTab(),
                SavedTab()
              ],
            )
          ),
          BottomTabs(
            selectedTab: _selectedTab,
            tabPressed: (num) {
              _tabPageController.animateToPage(num, duration: Duration(milliseconds: 300), curve: Curves.easeInCubic);
            },
          )
        ],
      )
    );
  }
}
