import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartCounter extends StatefulWidget {
  const CartCounter({super.key});

  @override
  State<CartCounter> createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
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
                if (currentProductDetails.currentProductQty > 1) {
                  setState(
                    () {
                      currentProductDetails.currentProductQty--;
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
                currentProductDetails.currentProductQty
                    .toString()
                    .padLeft(2, "0"),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            buildOutlineButton(
              icon: Icons.add,
              press: () {
                setState(
                  () {
                    currentProductDetails.currentProductQty++;
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
