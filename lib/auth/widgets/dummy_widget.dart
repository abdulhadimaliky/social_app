import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  @override
  profilePageState createState() => profilePageState();
}

class profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Profile',
          ),
          centerTitle: true,
          backgroundColor: Colors.grey.withOpacity(0.4),
          elevation: 0,
          // give the app bar rounded corners
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          leading: const Icon(
            Icons.menu,
          ),
        ),
        body: Column(
          children: <Widget>[
            // construct the profile details widget here
            const SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  'Profile Details Goes here',
                ),
              ),
            ),

            // the tab bar with two items
            SizedBox(
              height: 50,
              child: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.directions_bike),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.directions_car,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  Container(
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        'Bike',
                      ),
                    ),
                  ),

                  // second tab bar viiew widget
                  Container(
                    color: Colors.pink,
                    child: const Center(
                      child: Text(
                        'Car',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
