// ignore_for_file: unused_import

import 'package:curelink/pages/chat_page.dart';
import 'package:curelink/pages/login_page.dart';
import 'package:curelink/pages/main_page.dart';
import 'package:curelink/pages/schedule_page.dart';
import 'package:curelink/pages/signup_page.dart';
import 'package:curelink/pages/store_page.dart';
import 'package:curelink/redux/states/sidebar_state.dart';
import 'package:curelink/redux/states/user_details_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curelink/redux/states/navigation_state.dart';
import 'package:curelink/redux/reducer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redux/redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/menu.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('curelinkData');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Store<NavigationState> _bottomnavbarStore = Store<NavigationState>(
    navigationReducer,
    initialState: NavigationState(tabIndex: 0),
  );

  final Store<SidebarMenuState> _sidebarStore = Store<SidebarMenuState>(
    sidebarMenuReducer,
    initialState:
        SidebarMenuState(selectedTab: sidebarMenus[1], isClosed: false),
  );

  final Store<UserDetailsState> _userDetailsStore = Store<UserDetailsState>(
    userDetailsReducer,
    initialState: UserDetailsState(
        auth_uid: null, displayName: null, email: null, phoneNumber: null),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: _userDetailsStore,
      child: StoreProvider(
        store: _bottomnavbarStore,
        child: StoreProvider(
          store: _sidebarStore,
          child: MaterialApp(
            title: 'CureLink',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorSchemeSeed: const Color(0xff5a73d8),
              textTheme: GoogleFonts.comfortaaTextTheme(
                Theme.of(context).textTheme,
              ),
              scaffoldBackgroundColor: HexColor("#f6f8fe"),
              useMaterial3: true,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const MainPage(),
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
            },
          ),
        ),
      ),
    );
  }
}
