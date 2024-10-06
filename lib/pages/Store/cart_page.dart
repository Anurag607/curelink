import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curelink/components/login_warning_dialogue.dart';
import 'package:curelink/components/store/cart_card.dart';
import 'package:curelink/components/thank_you_dialogue.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:curelink/redux/states/user_details_state.dart';
import 'package:curelink/utils/database.dart';
import 'package:curelink/utils/scripts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:curelink/pages/Store/details_screen.dart';
import 'package:flutter/services.dart';
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
  User? currentUser;
  CureLinkDatabase db = CureLinkDatabase();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    currentUser = FirebaseAuth.instance.currentUser;

    return firebaseApp;
  }

  late final AnimationController _opacityControllerCartItems =
      AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final Animation<double> _opacityAnimationCartItems = CurvedAnimation(
    parent: _opacityControllerCartItems,
    curve: Curves.easeIn,
  );

  late final AnimationController _opacityControllerRedirect =
      AnimationController(
    duration: const Duration(seconds: 0),
    vsync: this,
  )..forward();

  late final Animation<double> _opacityAnimationRedirect = CurvedAnimation(
    parent: _opacityControllerRedirect,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _opacityControllerCartItems.dispose();
    _opacityControllerRedirect.dispose();
    super.dispose();
  }

  getOrder() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('orders');
    String uid = db.getUserDetails()["auth_uid"];
    List<dynamic> cart = [];
    dynamic temp = {};
    users.where("user", isEqualTo: uid).get().then((data) => {
          for (var i in data.docs)
            {
              temp["id"] = i.id,
              temp["cart"] = (i.data() as Map)["cart"],
              temp["totalCost"] = (i.data() as Map)["totalCost"],
              cart.add(temp),
            },
          log(cart.toString()),
        });
  }

  updateDB(cart, cost) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('orders');
    List<dynamic> items = [];
    dynamic temp = {};
    for (var item in cart) {
      temp = {
        'id': item.id,
        'image': item.image,
        'title': item.title,
        'price': item.price,
        'description': item.description,
        'type': item.type,
        'quantity': item.quantity,
      };
      items.add(temp);
    }
    String uid = db.getUserDetails()["auth_uid"];
    await users
        .add({
          'user': uid,
          'cart': items,
          'totalCost': cost,
          'timestamp': DateTime.now(),
        })
        .then((value) => log("User Added"))
        .catchError(
          (error) => log("Failed to add user: $error"),
        );
  }

  int totalPrice = 0;

  @override
  void initState() {
    getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: ((context, snapshot) {
          return StoreConnector<UserDetailsState, dynamic>(
            converter: (store) => store.state,
            builder: (BuildContext context, dynamic userDetails) {
              return StoreConnector<CartState, dynamic>(
                converter: (store) => store.state,
                builder: (BuildContext context, dynamic state) {
                  totalPrice = state.totalPrice;
                  int sum = 0;
                  for (var item in state.cart) {
                    sum += item.price * item.quantity as int;
                  }
                  log(sum.toString());
                  totalPrice = sum;
                  return Container(
                    color: HexColor("#f6f8fe"),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, bottom: 20),
                          color: HexColor("#5D3FD3"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 160,
                                child: Text(
                                  "Take a look at your cart !",
                                  style: GoogleFonts.comfortaa(
                                    textStyle: TextStyle(
                                      color: HexColor("#f6f8fe").withOpacity(1),
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 36,
                                    width: 120,
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.red.withOpacity(
                                            state.cart.isEmpty ? 0.6 : 1),
                                        shape: const StadiumBorder(),
                                      ),
                                      onPressed: () => {
                                        if (state.cart.isNotEmpty)
                                          {
                                            setState(() {
                                              StoreProvider.of<CartState>(
                                                      context)
                                                  .dispatch(
                                                DeleteCartAction(),
                                              );
                                            }),
                                          }
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: HexColor("#f6f8fe").withOpacity(
                                            state.cart.isEmpty ? 0.6 : 1),
                                        size: 14,
                                      ),
                                      label: Text(
                                        'Clear Cart',
                                        style: TextStyle(
                                          color: HexColor("#f6f8fe")
                                              .withOpacity(
                                                  state.cart.isEmpty ? 0.6 : 1),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15)
                                ],
                              ),
                            ],
                          ),
                        ),
                        (state.cart.isEmpty)
                            ? redirectFallback()
                            : FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: _opacityAnimationCartItems,
                                  curve: Curves.easeIn,
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.675,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Total Price:",
                                                      style:
                                                          GoogleFonts.comfortaa(
                                                        textStyle: TextStyle(
                                                            color: HexColor(
                                                                "#1a1a1c"),
                                                            fontSize: 22.5,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            HexColor("#5D3FD3"),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(5),
                                                        ),
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 15,
                                                        vertical: 10,
                                                      ),
                                                      child: Text(
                                                        "₹$totalPrice",
                                                        style: GoogleFonts
                                                            .comfortaa(
                                                          textStyle: TextStyle(
                                                              color: HexColor(
                                                                  "#f6f8fe"),
                                                              fontSize: 22.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(),
                                              const SizedBox(height: 20),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: state.cart.length,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        index) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                    ),
                                                    child: CartCard(
                                                      product:
                                                          state.cart[index],
                                                      press: () => {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailsScreen(
                                                              product: state
                                                                  .cart[index],
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
                                    ],
                                  ),
                                ),
                              ),
                        (state.cart.isEmpty)
                            ? Container()
                            : Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (CustomScripts.validateUserObjects(
                                              currentUser, userDetails) &&
                                          db.getUserDetails() == null) {
                                        showLoginWarningDialog(
                                          context,
                                          onValue: (_) {
                                            setState(() {});
                                          },
                                        );
                                        return;
                                      }
                                      updateDB(state.cart, totalPrice);
                                      showThanksDialog(
                                        context,
                                        onValue: (_) {
                                          setState(() {});
                                          StoreProvider.of<CartState>(context)
                                              .dispatch(
                                            DeleteCartAction(),
                                          );
                                        },
                                      );
                                    },
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
                                      padding:
                                          const EdgeInsets.only(bottom: 6.0),
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
                              ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }

  Widget redirectFallback() {
    return FadeTransition(
      opacity: _opacityAnimationRedirect,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: HexColor("#f6f8fe"),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3f000000),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Oops! Looks like your cart is empty!",
                textAlign: TextAlign.center,
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                      color: HexColor("#1a1a1c").withOpacity(0.75),
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("#5D3FD3"),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_back,
                  color: HexColor("#f6f8fe"),
                ),
                label: Text(
                  "Go to the Store",
                  style: TextStyle(
                    color: HexColor("#f6f8fe"),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
