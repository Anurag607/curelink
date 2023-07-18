import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:curelink/utils/database.dart';

class ThemedScreen extends StatelessWidget {
  final Widget topBar;
  final Widget child;
  ThemedScreen({required this.topBar, required this.child, super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  static final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  static final CureLinkDatabase db = CureLinkDatabase();

  final List<dynamic> _gradientList = [
    [HexColor("#AD1DEB"), HexColor("#6E72FC")],
    [HexColor("#5D3FD3"), HexColor("#1FD1F9")],
    [HexColor("#B621FE"), HexColor("#1FD1F9")],
    [HexColor("#E975A8"), HexColor("#726CF8")],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: HexColor("#5D3FD3"),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [HexColor("#5D3FD3"), HexColor("#1FD1F9")],
                tileMode: TileMode.mirror,
              ).createShader(
                Rect.fromLTRB(0, 0, rect.width, rect.height),
              );
            },
            blendMode: BlendMode.srcOut,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent),
          ),
          LiquidPullToRefresh(
            key: _refreshIndicatorKey,
            springAnimationDurationInMilliseconds: 300,
            height: 150,
            color: Colors.transparent,
            backgroundColor: HexColor("#f8f8f8"),
            borderWidth: 2,
            onRefresh: () async {
              db.getCart();
              await Future.delayed(const Duration(seconds: 2));
              _refreshIndicatorKey.currentState?.show();
            },
            showChildOpacityTransition: true,
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                  clipBehavior: Clip.antiAlias,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 35),
                          child: topBar),
                      child,
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
