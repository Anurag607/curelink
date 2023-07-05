import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/navigation_state.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<NavigationState, int>(
        converter: (store) => store.state.tabIndex,
        builder: (context, int stateNavigationIndex) => CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: stateNavigationIndex,
              height: 60,
              color: HexColor('#5D3FD3'),
              backgroundColor: HexColor('#f6f8fe'),
              buttonBackgroundColor: HexColor("#666fdb"),
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              onTap: (index) => {
                StoreProvider.of<NavigationState>(context)
                    .dispatch(UpdateNavigationIndexAction(index))
              },
              letIndexChange: (index) => true,
              items: [
                Icon(Ionicons.home, color: HexColor("#f6f8fe"), size: 30),
                Icon(Ionicons.cart, color: HexColor("#f6f8fe"), size: 30),
                Icon(Ionicons.chatbubble_ellipses,
                    color: HexColor("#f6f8fe"), size: 30),
              ],
            ));
  }
}
