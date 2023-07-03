import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Models/user.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/location.dart';
import 'package:izzup/Views/Map/map.dart';
import 'package:izzup/Views/Profile/profile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

import '../../Services/api.dart';
import '../../Services/prefs.dart';
import '../HomeScreen/home_screen.dart';
import '../JobOfferList/job_offer_list.dart';
import '../RequestList/request_list.dart';

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
    if (Globals.profile?.role == UserRole.extra) {
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
    } else {
      switch (index) {
        case 0:
          return _CurrentPage.home;
        case 1:
          return _CurrentPage.posts;
        case 2:
          return _CurrentPage.profile;
        default:
          return _CurrentPage.home;
      }
    }
  }

  Widget page() {
    switch (this) {
      case _CurrentPage.home:
        return const HomeScreen();
      case _CurrentPage.map:
        return const MapScreen();
      case _CurrentPage.posts:
        return const JobOfferListPage();
      case _CurrentPage.profile:
        return const ProfileScreen();
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
  late io.Socket socket;

  void checkPerm() async {
    print(await LocationService.isPermissionGranted());
  }

  @override
  void initState() {
    super.initState();
    checkPerm();
    listScreens = Globals.profile?.role == UserRole.extra ? [
      const HomeScreen(),
      const MapScreen(),
      const JobOfferListPage(),
      const ProfileScreen()
    ] : [
      const HomeScreen(),
      const JobOfferListPage(),
      const ProfileScreen()
    ];
    _createSocket();
  }

  _createSocket() async {
    final authToken = await Globals.authToken();
    socket = io.io(Api.getUriString('app-socket'),
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({'Authorization': 'Bearer $authToken'}) // optional
            .disableAutoConnect() // disable auto-connection
            .build());

    _connectToWebsocket();
  }

  _connectToWebsocket() async {
    socket.connect();
    socket.onConnect((data) => print(data));
    socket.onConnectError((data) => print(data));
    socket.on('job-request-accepted', (data) {
      print('accepted');
      print(data);
    });

    socket.on('job-request-confirmed', (data) {
      print('confirmed');
      print(data);
    });

    socket.on('job-request-finished', (data) {
      print('finished');
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: Globals.profile?.role == UserRole.extra ? 4 : 3,
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
                      icon: _currentPage.icon(_CurrentPage.home), label: ''),
                  if (Globals.profile?.role == UserRole.extra)
                    BottomNavigationBarItem(
                        icon: _currentPage.icon(_CurrentPage.map), label: ''),
                  BottomNavigationBarItem(
                      icon: _currentPage.icon(_CurrentPage.posts), label: ''),
                  BottomNavigationBarItem(
                      icon: _currentPage.icon(_CurrentPage.profile), label: ''),
                ]),
          ),
        ),
      ],
    );
  }
}

Future<T> showJobRequestSuccessModal<T>(BuildContext context) async {
  return await showModal(
      context, (context) => Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.accent,
                  Color(0xFF02c18a),
                ],
              ),
            ),
          ),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 50,
                ),
                SizedBox(height: 20),
                Text(
                  "A job offer has been accepted !",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          )
        ],
      )
  ));
}

Future<T> showJobEndModalExtra<T>(BuildContext context) async {
  return await showModal(
      context, (context) => Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 3.3),
                const Text(
                  "It's time to leave !",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Give this code to your employer",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
                const SizedBox(height: 75),
                const Text(
                  "1234",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 75,
                      fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          )
        ],
      )
  ));
}

Future<T> showJobEndModalEmployer<T>(BuildContext context) async {
  return await showModal(
      context, (context) => Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 3.3),
                  const Text(
                    "It's time to say goodbye...",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Enter the code provided by your employee",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                  const SizedBox(height: 75),
                  IntrinsicWidth(
                    stepWidth: MediaQuery.of(context).size.width / 10,
                    child: TextField(
                        textInputAction: TextInputAction.done,
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder:OutlineInputBorder(),
                            hintText: "1234",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic
                            )
                        ),
                        cursorColor: Colors.black,
                        style: const TextStyle(
                            fontSize: 75,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly,
                        ]
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
  ), isDismissible: false);
}

Future<T> showModal<T>(BuildContext context, WidgetBuilder builder, {isDismissible = true}) async {
  return await showModalBottomSheet(
    context: context,
    builder: builder,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
  );
}
