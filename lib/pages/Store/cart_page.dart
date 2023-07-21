import 'package:curelink/components/store/cart_card.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:curelink/models/product.dart';
import 'package:curelink/pages/Store/details_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late final AnimationController _opacityControllerCartItems =
      AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final Animation<double> _opacityAnimationCartItems = CurvedAnimation(
    parent: _opacityControllerCartItems,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _opacityControllerCartItems.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<CartState, dynamic>(
        converter: (store) => store.state.cart,
        builder: (BuildContext context, dynamic cart) => Container(
          color: HexColor("#f6f8fe"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                color: HexColor("#5D3FD3"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Take a look at your cart !",
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: HexColor("#f6f8fe").withOpacity(1),
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                      width: 90,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () => {
                          setState(() {
                            StoreProvider.of<CartState>(context).dispatch(
                              DeleteCartAction(),
                            );
                          })
                        },
                        icon: Icon(
                          Icons.delete,
                          color: HexColor("#f6f8fe"),
                          size: 14,
                        ),
                        label: Text(
                          'Clear Cart',
                          style: TextStyle(
                            color: HexColor("#f6f8fe"),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _opacityAnimationCartItems,
                  curve: Curves.easeIn,
                ),
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: cart.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: CartCard(
                                product: cart[index],
                                press: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                        product: cart[index],
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
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor("#5D3FD3"),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                        ),
                      ),
                    ),
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Icon(
                        Ionicons.cart,
                        color: HexColor("#f6f8fe"),
                        size: 32,
                      ),
                    ),
                    label: Text(
                      "Checkout",
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          color: HexColor("#f6f8fe"),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
