import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

Widget fallbackWidget(
    String message, String action, VoidCallback actionCallback) {
  return Container(
    width: 275,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.red[400],
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.comfortaa(
            textStyle: TextStyle(
                color: HexColor("#fafafa").withOpacity(1),
                fontSize: 12.5,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            actionCallback();
          },
          child: Text(action),
        ),
      ],
    ),
  );
}

class DropDownList extends StatefulWidget {
  final dynamic orders;
  const DropDownList({super.key, required this.orders});

  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  late List<bool> _isExpanded = [];
  late dynamic orders = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    orders = widget.orders;
    _isExpanded = List<bool>.generate(orders.length, (index) => false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      dividerColor: Colors.transparent,
      expandIconColor: Colors.deepPurple[400],
      expandedHeaderPadding: const EdgeInsets.all(0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded[index] = !isExpanded;
        });
      },
      children: orders.asMap().entries.map<ExpansionPanel>(
        (entry) {
          final int panelIndex = entry.key;
          final dynamic items = entry.value;
          return ExpansionPanel(
            isExpanded: _isExpanded[panelIndex],
            backgroundColor: Colors.transparent,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepPurple[100],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: HexColor("#5D3FD3"),
                    radius: 24,
                    child: Icon(
                      Icons.check,
                      size: 28,
                      color: HexColor("#f6f8fe"),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat("yMMMMd")
                            .format(items["timestamp"].toDate()),
                        style: GoogleFonts.comfortaa(
                          textStyle: TextStyle(
                              color: HexColor("#f6f6f6").withOpacity(0.8),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Final Amount: ₹${items["totalCost"].toString()}",
                        style: GoogleFonts.comfortaa(
                          textStyle: TextStyle(
                            color: HexColor("#f6f6f6").withOpacity(1),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Order ID: ${panelIndex + 1 < 10 ? "0" : ""}${panelIndex + 1}",
                      style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(
                          color: HexColor("#f6f6f6").withOpacity(1),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            body: SingleChildScrollView(
              clipBehavior: Clip.antiAlias,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                color: Colors.transparent,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items["cart"].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.9,
                      color: HexColor("#f6f8fe").withOpacity(0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: HexColor("#f6f8fe"),
                              boxShadow: [
                                BoxShadow(
                                  color: HexColor("#c5c5c5").withOpacity(0.75),
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: HexColor("#e8e8e8"),
                                radius: 24,
                                child: Image.asset(
                                    items["cart"][index]["image"].toString()),
                              ),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cost : ₹${items["cart"][index]["price"].toString()}",
                                    style: GoogleFonts.comfortaa(
                                      textStyle: TextStyle(
                                          color: HexColor("#1a1a1c")
                                              .withOpacity(0.8),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Quantity : ${items["cart"][index]["quantity"].toString()}",
                                    style: GoogleFonts.comfortaa(
                                      textStyle: TextStyle(
                                          color: HexColor("#1a1a1c")
                                              .withOpacity(0.8),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  items["cart"][index]["title"].toString(),
                                  style: GoogleFonts.comfortaa(
                                    textStyle: TextStyle(
                                        color: HexColor("#1a1a1c"),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class PastOrdersMenu {
  // ignore: non_constant_identifier_names
  void ModalBottomSheet(context, ordersData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: HexColor("#fefefe"),
      showDragHandle: false,
      builder: (context) {
        return Container(
          height: ordersData?.length > 0 || ordersData == null ? 500 : 100,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ordersData == null || ordersData?.length == 0
                    ? fallbackWidget(
                        "No orders found! Looks like you haven't ordered anything yet.",
                        "Go to Shop",
                        () {},
                      )
                    : DropDownList(orders: ordersData),
              ],
            ),
          ),
        );
      },
    );
  }
}
