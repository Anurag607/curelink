// ignore_for_file: deprecated_member_use

import 'package:curelink/components/store/categories.dart';
import 'package:curelink/components/store/item_card.dart';
import 'package:curelink/models/product.dart';
import 'package:curelink/pages/Store/cart_page.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:curelink/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:curelink/models/product_data.dart';
import 'package:curelink/pages/Store/details_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ionicons/Ionicons.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with TickerProviderStateMixin {
  final _curelinkData = Hive.box("curelinkData");
  CureLinkDatabase db = CureLinkDatabase();

  late final AnimationController _opacityControllerItems = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final Animation<double> _opacityAnimationItems = CurvedAnimation(
    parent: _opacityControllerItems,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    if (_curelinkData.get('cart') == null) {
      List<Product> cart = [];
      db.saveCart(cart, 0);
    } else {
      db.getCart();
    }
  }

  @override
  void dispose() {
    _opacityControllerItems.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StoreProvider.of<CartState>(context).dispatch(
      SetCartAction(db.cart, db.cartTotalPrice),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Container(
        color: HexColor("#f6f8fe"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      "Welcome to the CureLink Store !",
                      style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(
                          color: HexColor("#1a1a1c").withOpacity(0.8),
                          fontSize: 22.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Ionicons.search,
                            color: HexColor("#1a1a1c").withOpacity(0.8),
                            size: 30),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Ionicons.cart,
                            color: HexColor("#1a1a1c").withOpacity(0.8),
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
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Categories(),
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _opacityAnimationItems,
                curve: Curves.easeIn,
              ),
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: products.length,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                              left: (index & 1 == 0) ? 12 : 0,
                              right: (index & 1 == 1) ? 12 : 0,
                            ),
                            child: ItemCard(
                              product: products[index],
                              press: () => {
                                StoreProvider.of<CurrentProductState>(context)
                                    .dispatch(
                                  UpdateCurrentProductAction(
                                      products[index], 0),
                                ),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      product: products[index],
                                    ),
                                  ),
                                ),
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
