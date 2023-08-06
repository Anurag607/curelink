import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:curelink/models/product.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/Ionicons.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({
    super.key,
    required this.product,
    required this.inCart,
    required this.press,
  });

  final Product product;
  final bool inCart;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<CurrentProductState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, dynamic currentProductDetails) =>
          Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SizedBox(
          height: 50,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              backgroundColor: HexColor('#5D3FD3'),
            ),
            onPressed: () {
              if (!inCart) {
                StoreProvider.of<CartState>(context).dispatch(
                  AddtoCartAction(
                    currentProductDetails.currentProduct,
                    currentProductDetails.currentProductQty <= 0
                        ? 1
                        : currentProductDetails.currentProductQty,
                  ),
                );
                return;
              }
              StoreProvider.of<CartState>(context).dispatch(
                UpdateCartAction(
                  currentProductDetails.currentProduct,
                  currentProductDetails.currentProductQty <= 0
                      ? 1
                      : currentProductDetails.currentProductQty,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(
                    Ionicons.cart,
                    color: HexColor("#f6f8fe").withOpacity(1),
                    size: 30,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    (inCart ? "Update Cart" : "Add To Cart").toUpperCase(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: HexColor("#f6f8fe").withOpacity(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
