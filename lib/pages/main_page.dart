import 'dart:math' as math;

import 'package:curelink/Firebase/fire_auth.dart';
import 'package:curelink/Templates/standard_screen.dart';
import 'package:curelink/components/top_bar.dart';
import 'package:curelink/pages/Store/home_screen.dart';
import 'package:curelink/pages/chat_page.dart';
import 'package:curelink/redux/states/navigation_state.dart';
import 'package:curelink/utils/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rive/rive.dart' as rive;
import 'package:swipe_to/swipe_to.dart';
import 'package:curelink/pages/home_page.dart';
import 'package:curelink/widgets/custom_bottomnavbar.dart';
import '../../models/menu.dart';
import 'package:curelink/components/menu_btn.dart';
import 'package:curelink/components/side_bar.dart';

class MainPage extends StatefulWidget {
  final bool isConnected;
  const MainPage({super.key, required this.isConnected});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  User? currentUser;
  late bool isConnected = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    currentUser = FirebaseAuth.instance.currentUser;
    FireAuth.signOut();

    return firebaseApp;
  }

  bool isSideBarOpen = false;
  Menu selectedSideMenu = sidebarMenus.first;
  late rive.SMIBool isMenuOpenInput;

  // Animation Controllers...
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200))
    ..addListener(
      () {
        setState(() {});
      },
    );

  // Animations...
  late final Animation<double> scalAnimation = Tween<double>(begin: 1, end: 0.8)
      .animate(CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn));

  late final Animation<double> animation = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn));

  Widget child = Container(
    height: 1000,
    width: double.infinity,
    color: Colors.transparent,
  );

  late List<Widget> _widgetOptions = <Widget>[];

  CureLinkDatabase db = CureLinkDatabase();

  // Defining main widgets for each screen...
  @override
  void initState() {
    // db.clearDatabase();
    isConnected = widget.isConnected;
    _widgetOptions = [
      // Home Page...
      const ThemedScreen(
        topBar: TopBar(),
        child: HomePage(),
      ),
      // Store Page...
      const StorePage(),
      // Chat Page...
      ThemedScreen(
        topBar: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              "Chats",
              style: TextStyle(
                  fontSize: 25,
                  color: HexColor("#f6f8fe"),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        child: const ChatPage(),
      ),
    ];
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isConnected
        ? Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: HexColor("#2d2e42"),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/health_care.png', width: 150),
                    const SizedBox(height: 40),
                    const Text(
                      "No Internet Connection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                )),
          )
        : FutureBuilder(
            future: _initializeFirebase(),
            builder: ((context, snapshot) {
              return StoreConnector<NavigationState, int>(
                converter: (store) => store.state.tabIndex,
                builder: (context, int stateNavigationIndex) => Scaffold(
                  backgroundColor: HexColor("#666fdb"),
                  body: SwipeTo(
                    iconColor: Colors.transparent,
                    onRightSwipe: (DragUpdateDetails details) {
                      isMenuOpenInput.value = true;
                      _animationController.forward();
                      setState(
                        () {
                          isSideBarOpen = true;
                        },
                      );
                    },
                    onLeftSwipe: (DragUpdateDetails details) {
                      isMenuOpenInput.value = false;
                      _animationController.reverse();
                      setState(
                        () {
                          isSideBarOpen = false;
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 75,
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(1 * animation.value -
                                  30 * (animation.value) * math.pi / 180),
                            child: Transform.translate(
                              offset: Offset(animation.value * 265, 0),
                              child: Transform.scale(
                                scale: scalAnimation.value,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  child: SingleChildScrollView(
                                    clipBehavior: Clip.antiAlias,
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    child: Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              50,
                                      color: Colors.transparent,
                                      child:
                                          _widgetOptions[stateNavigationIndex],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedPositioned(
                            width: 288,
                            height: MediaQuery.of(context).size.height,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                            left: isSideBarOpen ? 0 : -288,
                            top: 0,
                            child: SideBar(closeSidebar: () {
                              _animationController.reverse();
                              setState(
                                () {
                                  isSideBarOpen = false;
                                },
                              );
                            }),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                            left: isSideBarOpen ? 220 : 0,
                            top: 16,
                            child: MenuBtn(
                              press: () {
                                isMenuOpenInput.value = !isMenuOpenInput.value;

                                if (_animationController.value == 0) {
                                  _animationController.forward();
                                } else {
                                  _animationController.reverse();
                                }

                                setState(
                                  () {
                                    isSideBarOpen = !isSideBarOpen;
                                  },
                                );
                              },
                              hide: isSideBarOpen && false,
                              riveOnInit: (artboard) {
                                final controller =
                                    rive.StateMachineController.fromArtboard(
                                        artboard, "State Machine");

                                artboard.addController(controller!);

                                isMenuOpenInput = controller
                                    .findInput<bool>("isOpen") as rive.SMIBool;
                                isMenuOpenInput.value = true;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: CurvedBottomNavBar(animation: animation),
                ),
              );
            }),
          );
  }
}
