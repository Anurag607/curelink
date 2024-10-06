// ignore_for_file: use_build_context_synchronously

import 'package:curelink/pages/profile_page.dart';
import 'package:curelink/pages/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:curelink/utils/database.dart';

import '../../../models/menu.dart';
import '../../../utils/rive_utils.dart';
import '../components/info_card.dart';
import '../components/side_menu.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/navigation_state.dart';

class SideBar extends StatefulWidget {
  final VoidCallback closeSidebar;
  const SideBar({super.key, required this.closeSidebar});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  CureLinkDatabase db = CureLinkDatabase();

  late VoidCallback _closeSidebar;

  @override
  void initState() {
    _closeSidebar = widget.closeSidebar;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(32),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(color: HexColor("#f6f8fe")),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              clipBehavior: Clip.antiAlias,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const InfoCard(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                    child: Text(
                      "Browse".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: HexColor("#f6f8fe")),
                    ),
                  ),
                  ...sidebarMenus.map(
                    (menu) {
                      return SideMenu(
                        menu: menu,
                        dispatch: () {
                          int selectedIndex = 0;
                          if (menu.title == 'Profile') {
                            Future.delayed(const Duration(milliseconds: 210))
                                .then(
                              (_) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              ),
                            );
                          } else if (menu.title == 'Home') {
                            selectedIndex = 0;
                          } else if (menu.title == 'Conversations') {
                            selectedIndex = 2;
                          } else if (menu.title == 'Schedule') {
                            Future.delayed(const Duration(milliseconds: 210))
                                .then(
                              (_) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SchedulePage(),
                                ),
                              ),
                            );
                          }
                          StoreProvider.of<NavigationState>(context).dispatch(
                            UpdateNavigationIndexAction(selectedIndex),
                          );
                        },
                        closeSidebar: _closeSidebar,
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      );
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                    child: Text(
                      "Utility".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: HexColor("#f6f8fe")),
                    ),
                  ),
                  ...sidebarMenus2.map(
                    (menu) => StoreConnector<NavigationState, int>(
                      converter: (store) => store.state.tabIndex,
                      builder: (context, int stateNavigationIndex) => SideMenu(
                        menu: menu,
                        dispatch: () {
                          if (menu.title == "Previous Appointments") {
                            Future.delayed(const Duration(milliseconds: 210))
                                .then(
                              (_) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Container(),
                                ),
                              ),
                            );
                          } else if (menu.title == "Settings & Privacy") {
                            Future.delayed(const Duration(milliseconds: 210))
                                .then(
                              (_) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Container(),
                                ),
                              ),
                            );
                          }
                        },
                        closeSidebar: _closeSidebar,
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
