import 'dart:developer';

import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartCounter extends StatefulWidget {
  final bool inCart;
  final int qty;
  const CartCounter({super.key, required this.inCart, required this.qty});

  @override
  State<CartCounter> createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  late bool inCart = false;
  late int qty = 0;

  @override
  void initState() {
    super.initState();
    inCart = widget.inCart;
    qty = widget.qty;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<CurrentProductState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, dynamic currentProductDetails) {
        return Row(
          children: <Widget>[
            buildOutlineButton(
              icon: Icons.remove,
              press: () {
                log(qty.toString());
                if (currentProductDetails.currentProductQty <= 1) {
                  qty = 0;
                  setState(
                    () {
                      if (inCart) {
                        StoreProvider.of<CartState>(context).dispatch(
                          RemovefromCartAction(
                            currentProductDetails.currentProduct,
                          ),
                        );
                      }
                      currentProductDetails.currentProductQty = 0;
                    },
                  );
                  return;
                } else if (currentProductDetails.currentProductQty > 1) {
                  qty -= 1;
                  setState(
                    () {
                      StoreProvider.of<CurrentProductState>(context).dispatch(
                        UpdateCurrentProductAction(
                          currentProductDetails.currentProduct,
                          currentProductDetails.currentProductQty - 1,
                        ),
                      );
                    },
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20 / 2),
              child: Text(
                (qty < 10) ? qty.toString().padLeft(2, "0") : qty.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            buildOutlineButton(
              icon: Icons.add,
              press: () {
                setState(
                  () {
                    qty += 1;
                    StoreProvider.of<CurrentProductState>(context).dispatch(
                      UpdateCurrentProductAction(
                        currentProductDetails.currentProduct,
                        currentProductDetails.currentProductQty + 1,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  SizedBox buildOutlineButton({IconData? icon, VoidCallback? press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}
