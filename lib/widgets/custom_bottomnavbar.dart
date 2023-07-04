import 'package:flutter/material.dart';
import 'package:ionicons/Ionicons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/navigation_state.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    void changeTabs(int tabIndex) {
      setState(() {
        UpdateNavigationIndexAction(tabIndex);
        if (tabIndex == 0) {
          Navigator.pushNamed(context, '/');
        } else if (tabIndex == 1) {
          Navigator.pushNamed(context, '/schedule');
        } else if (tabIndex == 2) {
          Navigator.pushNamed(context, '/chat');
        } else if (tabIndex == 3) {
          Navigator.pushNamed(context, '/profile');
        }
      });
    }

    return StoreConnector<NavigationState, int>(
      converter: (store) => store.state.tabIndex,
      builder: (context, int stateNavigationIndex) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: stateNavigationIndex,
        onTap: (currentIndex) => {
          changeTabs(currentIndex),
          StoreProvider.of<NavigationState>(context)
              .dispatch(UpdateNavigationIndexAction(currentIndex))
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Ionicons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.calendar), label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.chatbubble_ellipses), label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(Ionicons.person), label: "Profile"),
        ],
      ),
    );
  }
}
