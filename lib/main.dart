// ignore_for_file: unused_import
import 'dart:io';
import 'dart:developer' as dev;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curelink/fcm_api.dart';
import 'package:curelink/pages/notification_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:curelink/models/appointment.dart';
import 'package:curelink/models/doctor.dart';
import 'package:curelink/pages/Store/home_screen.dart';
import 'package:curelink/pages/chat_page.dart';
import 'package:curelink/pages/login_page.dart';
import 'package:curelink/pages/main_page.dart';
import 'package:curelink/pages/schedule_page.dart';
import 'package:curelink/pages/signup_page.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:curelink/redux/states/sidebar_state.dart';
import 'package:curelink/redux/states/user_details_state.dart';
import 'package:curelink/models/product.dart';
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

final navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  bool isConnected = false;
  await checkConnection().then((value) {
    if (value == false) {
      isConnected = false;
    } else {
      isConnected = true;
    }
  });
  await Hive.initFlutter();
  Hive.registerAdapter(DoctorAdapter());
  Hive.registerAdapter(AppointmentAdapter());
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox('curelinkData');
  if (isConnected) {
    await Firebase.initializeApp();
    await FCMApi().initNotification();
    HttpOverrides.global = MyHttpOverrides();
    WidgetsFlutterBinding.ensureInitialized();
  }
  runApp(MyApp(isConnected: isConnected));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.isConnected});
  final bool isConnected;

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

  final Store<CurrentProductState> _currentProductStore =
      Store<CurrentProductState>(
    updateCurrentProductReducer,
    initialState: CurrentProductState(
      currentProduct: null,
      currentProductQty: 0,
    ),
  );

  final Store<CartState> _cartStore = Store<CartState>(
    updateCartReducer,
    initialState: CartState(
      cart: [],
      totalPrice: 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: _userDetailsStore,
      child: StoreProvider(
        store: _bottomnavbarStore,
        child: StoreProvider(
          store: _sidebarStore,
          child: StoreProvider(
            store: _currentProductStore,
            child: StoreProvider(
              store: _cartStore,
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
                navigatorKey: navigatorKey,
                initialRoute: '/',
                routes: {
                  '/': (context) => MainPage(isConnected: isConnected),
                  '/login': (context) => const LoginPage(),
                  '/signup': (context) => const SignupPage(),
                  '/store': (context) => const StorePage(),
                  '/notifications': (context) => const NotificationPage(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
