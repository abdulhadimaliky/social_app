import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/models/user_model.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';

class Notificaitons extends StatefulWidget {
  const Notificaitons({super.key, required this.user});

  final UserModel user;

  @override
  State<Notificaitons> createState() => _NotificaitonsState();
}

class _NotificaitonsState extends State<Notificaitons> {
  @override
  void initState() {
    context.read<DashboardProvider>().getMyRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myrequests = context.watch<DashboardProvider>().myFriendRequests;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
                const Text("Notifications"),
                const SizedBox(width: 60),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Today"),
          ...myrequests.map((e) => Card(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                // color: Colors.amber,
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(e.senderImageUrl)),
                  title: Text("${e.senderName} send you a friend request"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat.jm().format(e.sentAt)),
                      Row(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                              onPressed: () {
                                context.read<DashboardProvider>().acceptFriendRequests(e.senderId, e.requestId);
                              },
                              child: const Text("Accept")),
                          const VerticalDivider(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade50,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                            onPressed: () {},
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );

    // ListView.builder(
    //   itemCount: myrequests.length,
    //   itemBuilder: (context, index) {
    //     return Column(
    //       children: [
    //         const Text("Notifications"),
    //         ...myrequests.map(
    //           (e) => ListTile(
    //             leading: CircleAvatar(
    //               backgroundImage: NetworkImage(e.senderImageUrl),
    //             ),
    //             title: Text(e.senderName),
    //             subtitle: Text(e.sentAt.toString()),
    //           ),
    //         ),
    //       ],
    //     );
    //     // return context.watch<DashboardProvider>().myFriendRequests.map((e) => ListTile());
    //   },
    // );
  }
}
