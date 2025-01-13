import 'package:app/core/helpers/app_utilities.dart';
import 'widgets/dashboard_screen.dart';
import 'widgets/settings.dart';
import 'package:flutter/material.dart';

import '../../../core/theming/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedScreen = 0;

  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    makeScreens();
  }

  makeScreens() {
    screens = [const DashboardScreen(), const SettingsScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // appBar: AppBar(),
      body: Container(),
      floatingActionButton: qrScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: bottomNav(),
    );
  }

  FloatingActionButton qrScanButton() {
    if (AppUtilities().loginData.roleName == "Client") {
      return FloatingActionButton(backgroundColor: Colors.transparent, elevation: 0, onPressed: () {});
    }

    return FloatingActionButton(
      backgroundColor: primaryColor,
      shape: const CircleBorder(side: BorderSide(color: bgColor, width: 3)),
      onPressed: () async {
        //goToScanScreen();
      },
      child: const Icon(
        Icons.qr_code,
        color: Colors.white,
      ),
    );
  }

  BottomNavigationBar bottomNav() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: primaryColor,
      onTap: (index) {
        setState(() {
          selectedScreen = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          label: "Dashboard",
          icon: Icon(
            Icons.home_rounded,
            color: selectedScreen == 0 ? Colors.white : Colors.white.withAlpha(128),
            size: selectedScreen == 0 ? 30 : 20,
          ),
        ),
        BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(
              Icons.settings_rounded,
              color: selectedScreen == 1 ? Colors.white : Colors.white.withAlpha(128),
              size: selectedScreen == 1 ? 30 : 20,
            )),
      ],
    );
  }
}
