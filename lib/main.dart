import 'package:curelink/pages/chat_page.dart';
import 'package:curelink/pages/profile_page.dart';
import 'package:curelink/pages/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:curelink/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curelink/redux/states/navigation_state.dart';
import 'package:curelink/redux/reducer.dart';
import 'package:redux/redux.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Store<NavigationState> _store = Store<NavigationState>(
    navigationReducer,
    initialState: NavigationState(tabIndex: 0),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: _store,
        child: MaterialApp(
            title: 'CureLink',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorSchemeSeed: const Color(0xff5a73d8),
              textTheme: GoogleFonts.comfortaaTextTheme(
                Theme.of(context).textTheme,
              ),
              scaffoldBackgroundColor: HexColor("#fefefe"),
              useMaterial3: true,
            ),
            initialRoute: '/',
            routes: {
              '/': ((context) => const HomePage(title: 'CureLink')),
              '/schedule': ((context) => const SchedulePage()),
              '/chat': ((context) => const ChatPage()),
              '/profile': ((context) => const ProfilePage()),
            }));
  }
}
