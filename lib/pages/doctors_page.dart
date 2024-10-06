import 'package:curelink/components/doctor_cards.dart';
import 'package:curelink/models/doctor_data.dart';
import 'package:curelink/utils/scripts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage>
    with TickerProviderStateMixin {
  late final AnimationController _opacityControllerAddAppointments =
      AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final Animation<double> _opacityAnimationAddAppointments =
      CurvedAnimation(
    parent: _opacityControllerAddAppointments,
    curve: Curves.easeIn,
  );

  late List<dynamic> results = [];
  bool isLoading = false;
  bool active = false;
  String query = "";
  late List<dynamic> searchResults = [];

  final searchQueryController = TextEditingController();
  FocusNode searchQueryFocusNode = FocusNode();

  @override
  void initState() {
    searchResults = doctors;
    super.initState();
  }

  void handleSearch(String query) async {
    setState(() {
      isLoading = true;
    });
    results = FilterAppointments.filterAppointments(query);
    if (query == "") {
      setState(() {
        active = false;
        searchResults = doctors;
      });
    } else {
      setState(() {
        active = true;
        searchResults = results;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 100.00,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: HexColor("#f6f8fe"),
      body: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  // Search Bar...
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0.5, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              focusNode: searchQueryFocusNode,
                              controller: searchQueryController,
                              onChanged: handleSearch,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search by Name or Profession",
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              searchQueryController.clear();
                              searchQueryFocusNode.unfocus();
                              setState(() {
                                active = false;
                                searchResults = doctors;
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: HexColor("#1a1a1c")
                                  .withOpacity(active ? 1 : 0.5),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
              (isLoading)
                  ? progressIndicator()
                  : (searchResults.isEmpty)
                      ? fallback()
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: SingleChildScrollView(
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _opacityAnimationAddAppointments,
                                curve: Curves.easeIn,
                              ),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: searchResults.length,
                                    physics: const ScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          DoctorCards(
                                            name: searchResults[index].name,
                                            desc: searchResults[index].desc,
                                            rating: searchResults[index].rating,
                                            reviews: searchResults[index]
                                                .reviews
                                                .length,
                                            image: searchResults[index].image,
                                            press: () {},
                                          ),
                                          const SizedBox(
                                            width: double.infinity,
                                            height: 8,
                                          )
                                        ],
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
      ),
    );
  }

  Widget progressIndicator() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 25),
          CircularProgressIndicator(
            color: HexColor("#2d2e42"),
          ),
        ],
      ),
    );
  }

  Widget fallback() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: InkWell(
          onTap: () => {},
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Ink(
            decoration: BoxDecoration(
              color: HexColor("#ffffff"),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 0,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: const Center(
                child: Text(
                  "No results found.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
