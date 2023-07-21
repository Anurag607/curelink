import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rive/rive.dart';
import 'package:curelink/utils/database.dart';
import '../../../models/menu.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/sidebar_state.dart';

class SideMenuCard extends StatelessWidget {
  final Menu menu;
  final VoidCallback dispatch;
  final VoidCallback press;
  final VoidCallback closeSidebar;
  final ValueChanged<Artboard> riveOnInit;
  final bool? isExpanded;

  const SideMenuCard({
    super.key,
    required this.menu,
    required this.dispatch,
    required this.press,
    required this.closeSidebar,
    required this.riveOnInit,
    this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<SidebarMenuState, Menu>(
        converter: (store) => store.state.selectedTab,
        builder: (context, Menu selectedTab) {
          if (isExpanded == true) {
            StoreProvider.of<SidebarMenuState>(context)
                .dispatch(UpdateSelectedTabAction(menu, false));
          }
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                width: selectedTab == menu ? 288 : 0,
                height: 56,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor("#5D3FD3"),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10)),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  StoreProvider.of<SidebarMenuState>(context)
                      .dispatch(UpdateSelectedTabAction(menu, true));
                  dispatch();
                  press();
                  closeSidebar();
                },
                leading: SizedBox(
                  height: 36,
                  width: 36,
                  child: RiveAnimation.asset(
                    menu.rive.src,
                    artboard: menu.rive.artboard,
                    onInit: riveOnInit,
                  ),
                ),
                title: Text(
                  menu.title,
                  style: TextStyle(color: HexColor("#f6f8fe")),
                ),
              ),
            ],
          );
        });
  }
}

class SideMenu extends StatefulWidget {
  final Menu menu;
  final VoidCallback press;
  final VoidCallback dispatch;
  final ValueChanged<Artboard> riveOnInit;
  final VoidCallback closeSidebar;

  const SideMenu({
    super.key,
    required this.menu,
    required this.dispatch,
    required this.press,
    required this.riveOnInit,
    required this.closeSidebar,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  CureLinkDatabase db = CureLinkDatabase();

  late Menu menu;
  late VoidCallback press;
  late VoidCallback dispatch;
  late VoidCallback closeSidebar;
  late ValueChanged<Artboard> riveOnInit;
  late Menu selectedMenu;

  @override
  void initState() {
    menu = widget.menu;
    press = widget.press;
    dispatch = widget.dispatch;
    closeSidebar = widget.closeSidebar;
    riveOnInit = widget.riveOnInit;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 10, top: 10),
          child: Divider(color: HexColor("#f6f8fe"), height: 1),
        ),
        SideMenuCard(
          menu: menu,
          press: press,
          closeSidebar: closeSidebar,
          dispatch: dispatch,
          riveOnInit: riveOnInit,
        ),
      ],
    );
  }
}
