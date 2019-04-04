import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rento/UIs/RHBuyer.dart';
import 'package:rento/UIs/RentalHistory.dart';
import 'package:rento/api/services.dart';
import 'package:rento/components/SideMenu.dart';
import 'package:rento/components/SideMenu.dart';
class RentalHistorySlider extends StatefulWidget {
  @override
  _RentalHistorySlider createState() => new _RentalHistorySlider();
}

class _RentalHistorySlider extends State<RentalHistorySlider>
with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return DefaultTabController(
    //   length: 2,
    //       child: Scaffold(
    //     appBar: AppBar(
    //       title: Text('Example App'),
    //       bottom: TabBar(
    //         tabs: <Widget>[
    //           Tab(
    //             text: "Home",
    //             icon: Icon(Icons.home),
    //           ),
    //           Tab(
    //             text: "Example page",
    //             icon: Icon(Icons.help),
    //           )
    //         ],
    //       ),
    //     ),

    return Scaffold(
      drawer: SideMenu(),
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Rental History'),
              pinned: true,
              floating: true,
              forceElevated: boxIsScrolled,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "Seller History",
                  ),
                  Tab(
                    text: "Buyer History",
                  )
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            RentalHistory(),RHBuyer()
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_upward, size: 30,),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          _scrollViewController
              .jumpTo(_scrollViewController.position.minScrollExtent);
        },
      ),
    );
  }
  Widget W(){
    return Container(color: Colors.deepOrangeAccent,);
  }
}