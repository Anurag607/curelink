import 'dart:developer';
import 'dart:ui';

import 'package:curelink/components/store/add_to_cart.dart';
import 'package:curelink/components/store/cart_counter.dart';
import 'package:curelink/components/store/color_and_type.dart';
import 'package:curelink/components/store/description.dart';
import 'package:curelink/components/store/product_title_with_image.dart';
import 'package:curelink/models/product.dart';
import 'package:curelink/pages/Store/cart_page.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class DetailsScreen extends StatefulWidget {
  final dynamic product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Product product;
  bool inCart = false;
  int qty = 0;

  @override
  void initState() {
    product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<CartState, dynamic>(
      converter: (store) => store.state.cart,
      builder: (BuildContext context, dynamic cart) {
        int index = cart.indexWhere((element) => element.id == product.id);
        if (index != -1) {
          inCart = true;
          qty = product.quantity;
        }
        log(qty.toString());
        return Scaffold(
          backgroundColor: HexColor('#5D3FD3'),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 0.00,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      HexColor("#5D3FD3"),
                      HexColor("#1FD1F9"),
                      HexColor("#666fdb")
                    ],
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
                springAnimationDurationInMilliseconds: 300,
                height: 150,
                color: Colors.transparent,
                backgroundColor: HexColor("#f6f8fe"),
                borderWidth: 2,
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
                showChildOpacityTransition: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 150),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            ProductTitleWithImage(product: product),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  left: 20,
                                  right: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: HexColor("#f6f8fe"),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    ColorAndType(product: product),
                                    const SizedBox(height: 10),
                                    Description(product: product),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CartCounter(
                                            inCart: inCart,
                                            qty: qty,
                                          ),
                                          AddToCart(
                                            product: product,
                                            inCart: inCart,
                                            press: () {
                                              setState(() {
                                                qty += 1;
                                                inCart = true;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(50)),
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 60),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.only(bottom: 25, left: 10),
                            child: IconButton(
                              icon: Icon(
                                Ionicons.arrow_back,
                                color: HexColor("#f6f8fe").withOpacity(1),
                                size: 30,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Container(
                            margin:
                                const EdgeInsets.only(bottom: 25, right: 25),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  width: 1.5,
                                  color: HexColor("#f6f8fe"),
                                ),
                              ),
                              label: Text(
                                "Cart",
                                style: GoogleFonts.comfortaa(
                                  textStyle: TextStyle(
                                    color: HexColor("#f6f8fe").withOpacity(0.8),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              icon: Icon(Ionicons.cart,
                                  color: HexColor("#f6f8fe").withOpacity(1),
                                  size: 30),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CartPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
