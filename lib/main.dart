import 'package:curelink/pages/chat_page.dart';
import 'package:curelink/pages/store_page.dart';
import 'package:curelink/widgets/hidden_drawer.dart';
import 'package:flutter/material.dart';
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

  static const List<Widget> _widgetOptions = <Widget>[
    HiddenDrawer(),
    StorePage(),
    ChatPage(),
  ];

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
              scaffoldBackgroundColor: HexColor("#f6f8fe"),
              useMaterial3: true,
            ),
            initialRoute: '/',
            routes: {
              '/': ((context) => StoreConnector<NavigationState, int>(
                  converter: (store) => store.state.tabIndex,
                  builder: (context, int stateNavigationIndex) =>
                      _widgetOptions[stateNavigationIndex])),
            }));
  }
}
