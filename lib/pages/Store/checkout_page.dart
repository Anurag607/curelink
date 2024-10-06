import "package:flutter/material.dart";
import "package:hexcolor/hexcolor.dart";
import "package:timeline_tile/timeline_tile.dart";

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f6f8fe"),
      body: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 10.00),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: HexColor("#1a1a1c").withOpacity(0.8),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 20.00),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    clipBehavior: Clip.antiAlias,
                    children: [
                      customTimelineTile(
                        true,
                        false,
                        true,
                        "Order Placed",
                        "Your order has been placed",
                      ),
                      customTimelineTile(
                        false,
                        false,
                        true,
                        "Order Confirmed",
                        "We have recieved your order.",
                      ),
                      customTimelineTile(
                        false,
                        false,
                        true,
                        "Order Shipped",
                        "Your order has been shiiped",
                      ),
                      customTimelineTile(
                        false,
                        true,
                        false,
                        "Order Delivered",
                        "Your order has been delivered",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTimelineTile(isFirst, isLast, isPast, message1, message2) {
    return SizedBox(
      height: 165,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? HexColor("#5D3FD3") : Colors.deepPurple.shade100,
          thickness: 5,
        ),
        indicatorStyle: IndicatorStyle(
          color: isPast ? HexColor("#5D3FD3") : Colors.deepPurple.shade100,
          width: 40,
          height: 40,
          indicatorXY: 0.5,
          iconStyle: IconStyle(
            color: isPast ? Colors.white : HexColor("#5D3FD3"),
            iconData: isPast ? Icons.check : Icons.circle,
          ),
        ),
        endChild: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.00),
          margin: const EdgeInsets.only(bottom: 20, left: 7.5),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message1,
                style: TextStyle(
                  color:
                      isPast ? HexColor("#5D3FD3") : Colors.deepPurple.shade100,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message2,
                style: TextStyle(
                  color:
                      isPast ? HexColor("#5D3FD3") : Colors.deepPurple.shade100,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
