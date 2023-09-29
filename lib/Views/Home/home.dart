import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Models/job_offer_requests.dart';
import 'package:izzup/Models/user.dart';
import 'package:izzup/Services/colors.dart';
import 'package:izzup/Services/location.dart';
import 'package:izzup/Views/Map/map.dart';
import 'package:izzup/Views/Profile/profile.dart';
import 'package:izzup/Views/RequestList/request_list_extra.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

import '../../Services/api.dart';
import '../../Services/modals.dart';
import '../HomeScreen/home_screen.dart';
import '../JobOfferList/job_offer_list.dart';

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
        return Globals.profile?.role == UserRole.employer
            ? const JobOfferListPage()
            : const RequestListExtra();
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
    if (kDebugMode) print(await LocationService.isPermissionGranted());
  }

  @override
  void initState() {
    super.initState();
    checkPerm();
    listScreens = Globals.profile?.role == UserRole.extra
        ? [
            const HomeScreen(),
            const MapScreen(),
            const RequestListExtra(),
            const ProfileScreen()
          ]
        : [const HomeScreen(), const JobOfferListPage(), const ProfileScreen()];
    if (Globals.profile?.status == UserVerificationStatus.verified) {
      _checkForAwaitingRequests();
    } else {
      print(Globals.profile?.status);
      Timer(const Duration(milliseconds: 500), () {
        if (Globals.profile?.status == UserVerificationStatus.unverified) {
          Modals.showModalNeedsVerification();
        }
        if (Globals.profile?.status == UserVerificationStatus.needsId) {
          Modals.showModalNeedsVerification();
        }
        if (Globals.profile?.status == UserVerificationStatus.notValid) {
          Modals.showModalNeedsVerification();
        }
      });
    }
  }

  _checkForAwaitingRequests() {
    if (Globals.profile == null) return;
    if (Globals.profile?.role == UserRole.extra) {
      Api.getExtraRequests().then((value) {
        if (value == null) return;
        var requests = value.requests.where((element) =>
            element.status == JobRequestStatus.waitingForVerification);
        if (requests.isNotEmpty && requests.first.verificationCode != null) {
          Modals.showJobEndModalExtra(
              requests.first.verificationCode!, requests.first.id!);
        }
      });
    } else {
      Api.getMyJobOffers().then((value) {
        if (value == null) return;
        var requestsFromJobOffers =
            value.map((e) => e.requests).expand((element) => element).toList();
        var requests = requestsFromJobOffers.where((element) =>
            JobRequestStatus.fromString(element.status) ==
            JobRequestStatus.waitingForVerification);
        if (requests.isNotEmpty) {
          for (var element in requests) {
            if (element.id == null) continue;
            Modals.showJobEndModalEmployer(element.id!);
          }
        }
      });
    }
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
