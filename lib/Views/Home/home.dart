import 'package:flutter/material.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Views/Map/map.dart';

import '../HomeScreen/home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum _CurrentPage {
  home,
  map,
  posts,
  profile;

static _CurrentPage forIndex(int index) {
switch (index) {
case 0:
return _CurrentPage.home;
case 1:
return _CurrentPage.map;
case 2:
return _CurrentPage.posts;
case 3:
return _CurrentPage.profile;
default:
return _CurrentPage.home;
}
}

Widget page() {
  switch (this) {
    case _CurrentPage.home:
      return const HomeScreen();
    case _CurrentPage.map:
      return const MapScreen();
    case _CurrentPage.posts:
      return _CurrentPage.home.icon(_CurrentPage.posts);
    case _CurrentPage.profile:
      return _CurrentPage.home.icon(_CurrentPage.profile);
    default:
      return const SizedBox();
  }
}

Image icon(_CurrentPage page) {
  return Image(
    image: AssetImage('assets/icon_${_iconName(page)}.png'),
    height: 24,
  );
}

String _iconName(_CurrentPage page) {
  switch (page) {
    case _CurrentPage.home:
      return "home${page == this ? '_filled' : ''}";
    case _CurrentPage.map:
      return "map${page == this ? '_filled' : ''}";
    case _CurrentPage.posts:
      return "book${page == this ? '_filled' : ''}";
    case _CurrentPage.profile:
      return "user${page == this ? '_filled' : ''}";
    default:
      return "home${page == this ? '_filled' : ''}";
  }
}
}

class _HomeState extends State<Home> {
  var _currentPage = _CurrentPage.home;
  int tabIndex = 0;
  late List<Widget> listScreens;

  @override
  void initState() {
    listScreens = [
      const HomeScreen(),
      const MapScreen(),
      _CurrentPage.home.icon(_CurrentPage.posts),
      _CurrentPage.home.icon(_CurrentPage.profile)
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: IndexedStack(index: tabIndex, children: listScreens),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.accent,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: tabIndex,
            onTap: (int index) {
              setState(() {
                tabIndex = index;
                _currentPage = _CurrentPage.forIndex(index);
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: _currentPage.icon(_CurrentPage.home),
                  label: ''
              ),
              BottomNavigationBarItem(
                  icon: _currentPage.icon(_CurrentPage.map),
                  label: ''
              ),
              BottomNavigationBarItem(
                  icon: _currentPage.icon(_CurrentPage.posts),
                  label: ''
              ),
              BottomNavigationBarItem(
                  icon: _currentPage.icon(_CurrentPage.profile),
                  label: ''
              ),
            ]
        ),
      ),
    );
  }
}
