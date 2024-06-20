import 'package:flutter/material.dart';
import 'package:flutterapp/core/storage/storage.dart';
import 'package:flutterapp/features/feed/presentation/views/home_page.dart';
import 'package:flutterapp/features/forums/presentation/views/search_screen.dart';
import 'package:flutterapp/features/members/presentation/views/member_list_screen.dart';

import '../../../profile/presentation/views/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  String? ownerId;
  Future<String> fetchId() async {
    String? ownerId = await Storage().secureStorage.read(key: 'userId');
    return ownerId ?? "Anonymous";
  }

  String? image;
  Future<String> fetchImage() async {
    String? avatar = await Storage().secureStorage.read(key: 'avatar');
    return avatar ??
        "https://lh3.googleusercontent.com/a/ACg8ocIKA_Jkp2pWe0wuRjRJvAGJ0_tdjLSK2iBDmIVGTjRAe6B6EJDW=s96-c";
  }

  @override
  void initState() {
    fetchId().then((value) {
      setState(() {
        ownerId = value;
      });
    });
    super.initState();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ForumScreen(),
    MemberListScreen(),
    ProfileScreen(ownerId: ''),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(
          _selectedIndex,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }

  //-----------------------------------------
}