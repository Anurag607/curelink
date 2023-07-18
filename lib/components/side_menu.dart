import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final ValueChanged<Artboard> riveOnInit;
  final bool? isExpanded;

  const SideMenuCard({
    super.key,
    required this.menu,
    required this.dispatch,
    required this.press,
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
                  style: const TextStyle(color: Colors.white),
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
  late ValueChanged<Artboard> riveOnInit;
  late Menu selectedMenu;

  bool _isExpanded = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    menu = widget.menu;
    press = widget.press;
    dispatch = widget.dispatch;
    riveOnInit = widget.riveOnInit;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, bottom: 10, top: 10),
          child: Divider(color: Colors.white24, height: 1),
        ),
        (menu.title == 'Music')
            ? ExpansionPanelList(
                elevation: 0,
                dividerColor: Colors.transparent,
                expandIconColor: Colors.white,
                expandedHeaderPadding: const EdgeInsets.only(bottom: 10),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _isExpanded = !isExpanded;
                  });
                },
                children: List<int>.filled(1, 1).map<ExpansionPanel>(
                  (_) {
                    return ExpansionPanel(
                      isExpanded: _isExpanded,
                      backgroundColor: Colors.transparent,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return SideMenuCard(
                          menu: menu,
                          press: press,
                          dispatch: dispatch,
                          riveOnInit: riveOnInit,
                          isExpanded: _isExpanded,
                        );
                      },
                      body: SingleChildScrollView(
                        clipBehavior: Clip.antiAlias,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                            height: 130, width: 250, color: Colors.transparent),
                      ),
                    );
                  },
                ).toList(),
              )
            : SideMenuCard(
                menu: menu,
                press: press,
                dispatch: dispatch,
                riveOnInit: riveOnInit,
              ),
      ],
    );
  }

  Widget fallbackWidget(
      String message, String action, VoidCallback actionCallback) {
    return Container(
      width: 275,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red[400],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
              textStyle: TextStyle(
                  color: HexColor("#fafafa").withOpacity(1),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              actionCallback();
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
