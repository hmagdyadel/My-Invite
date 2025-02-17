import 'package:app/core/helpers/app_utilities.dart';
import 'package:app/core/helpers/extensions.dart';
import 'package:app/core/routing/routes.dart';
import 'package:app/core/services/new_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/home_cubit.dart';
import '../logic/home_states.dart';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int selectedScreen = 0;

  List<Widget> screens = [const DashboardScreen(), const SettingsScreen()];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setFirebase());

  }
  void setFirebase() async {
    try {

      try {
        //await _firebaseMessaging.subscribeToTopic(topic);
      } catch (e) {
        print("error is ${e.toString()}");
      }
      FirebaseMessaging.instance.getToken().then((onValue){
        debugPrint("fcm-token is $onValue");
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Notification body onMessage: ${message.notification?.toMap().toString()}");

        if (!mounted) return; // Early return if the widget is not mounted

        final data = message.data;

        NewNotificationService().showNotificationWithActions(
          id: 1, // Unique ID for the notification
          title: "New Exam Notification",
          body: "You have an exam question waiting.",
          payload: data.toString(),
        );
      });



    } catch (e) {
      if (mounted) {
        context.showErrorToast('Failed to subscribe to topic. Please try again.');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          // appBar: AppBar(),
          body: body(),
          floatingActionButton: qrScanButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: bottomNav(),
        );
      },
    );
  }

  Widget body() {
    return screens[selectedScreen];
  }

  FloatingActionButton qrScanButton() {
    if (AppUtilities().loginData.roleName == "Client") {
      return FloatingActionButton(backgroundColor: Colors.transparent, elevation: 0, onPressed: () {});
    }

    return FloatingActionButton(
      backgroundColor: primaryColor,
      shape: const CircleBorder(side: BorderSide(color: bgColor, width: 3)),
      onPressed: () async {
        context.pushNamed(Routes.qrCodeScreen);
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
      backgroundColor: navBarBackground,
      onTap: (index) {
        setState(() {
          debugPrint("index: $index");
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
