import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/common/widgets/header.dart';
import 'package:social_app/auth/widgets/search_bar.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';
import 'package:social_app/chat/screens/inbox_screen.dart';
import 'package:social_app/dashboard/widgets/post_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    context.read<DashboardProvider>().getAllPosts();
    context.read<DashboardProvider>().unreadMessageCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Color(0xffFFFFFF),
          ),
          height: MediaQuery.of(context).size.height * 0.2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Header(
                  screenTitle: "People",
                  endIcon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InboxScreen()));
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            size: 30,
                            Icons.bolt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      context.watch<DashboardProvider>().unreadMessagesCount.isEmpty
                          ? const SizedBox()
                          : Positioned(
                              top: -5,
                              right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                maxRadius: 10,
                                child: Text(
                                  context.watch<DashboardProvider>().unreadMessagesCount.length.toString(),
                                  style: const TextStyle(fontSize: 13, color: Colors.black),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                const SearchBar(),
              ],
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: context.watch<DashboardProvider>().allPosts.length,
                itemBuilder: (context, index) {
                  final postModel = context.watch<DashboardProvider>().allPosts[index];
                  return PostCard(
                    post: postModel,
                  );
                })),
      ],
    );
  }
}
