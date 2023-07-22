import 'package:curelink/models/product.dart';
import 'package:curelink/redux/actions.dart';
import 'package:curelink/redux/states/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hexcolor/hexcolor.dart';

class Counter extends StatefulWidget {
  final Product product;
  const Counter({super.key, required this.product});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late Product product;

  @override
  void initState() {
    product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            if (product.quantity <= 1) {
              setState(
                () {
                  StoreProvider.of<CartState>(context).dispatch(
                    RemovefromCartAction(
                      product,
                    ),
                  );
                  product.quantity = 0;
                },
              );
              return;
            } else if (product.quantity > 1) {
              setState(
                () {
                  StoreProvider.of<CartState>(context).dispatch(
                    UpdateCartAction(
                      product,
                      product.quantity - 1,
                    ),
                  );
                },
              );
              return;
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20 / 2),
          child: Text(
            product.quantity.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        buildOutlineButton(
          icon: Icons.add,
          press: () {
            setState(
              () {
                StoreProvider.of<CartState>(context).dispatch(
                  UpdateCartAction(
                    product,
                    product.quantity + 1,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData? icon, VoidCallback? press}) {
    return SizedBox(
      width: 27,
      height: 22,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: press,
        child: Icon(icon, size: 17.5),
      ),
    );
  }
}

class CartCard extends StatelessWidget {
  final Product product;
  final VoidCallback press;

  const CartCard({required this.product, required this.press, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        StoreProvider.of<CurrentProductState>(context).dispatch(
          UpdateCurrentProductAction(product, product.quantity),
        );
        press();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.only(bottom: 20),
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
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Image...
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: HexColor("#5a73d8").withOpacity(0.2),
              ),
              child: Center(
                child: Image.asset(
                  product.image,
                  width: 80,
                  height: 94,
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.noRepeat,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Item Details...
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(product.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Text(product.type,
                        style: const TextStyle(
                          color: Colors.black54,
                        ))),
                const SizedBox(height: 18),
                // Item price and quantity...
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: HexColor("#5a73d8").withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Price : ",
                            style: TextStyle(
                              color: HexColor("#37474f"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "₹",
                            style: TextStyle(
                              color: HexColor("#37474f"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${product.price * product.quantity}",
                            style: TextStyle(
                              color: HexColor("#37474f"),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Counter(product: product),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
