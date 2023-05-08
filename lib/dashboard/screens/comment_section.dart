import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_app/dashboard/models/post_model.dart';
import 'package:social_app/dashboard/providers/dashboard_provider.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key, required this.postModel});

  final PostModel postModel;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DashboardProvider>().openCommentsStream(widget.postModel.postId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comment Section")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Builder(builder: (context) {
                  final comments = context.watch<DashboardProvider>().comments;
                  return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(comment.commenterImageUrl)),
                          title: Card(
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.white10)),
                              elevation: 0,
                              color: const Color(0xff007AFF).withOpacity(0.04),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.commenterName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      DateFormat.jm().format(comment.commentAt),
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    // const Divider(),
                                    const SizedBox(height: 5),
                                    Text(
                                      comment.text,
                                      style: TextStyle(color: const Color(0xff111129).withOpacity(0.7)),
                                    ),
                                  ],
                                ),
                              )),
                          subtitle: Row(
                            children: const [Text("Like"), VerticalDivider(color: Colors.grey), Text("Reply")],
                          ),
                          trailing: PopupMenuButton(
                              icon: const Icon(Icons.more_horiz),
                              onSelected: (value) {},
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: Row(
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(Icons.edit, color: Colors.blue),
                                            ),
                                            Text("Edit")
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(Icons.delete, color: Colors.red),
                                            ),
                                            Text("Delete")
                                          ],
                                        )),
                                  ]),
                        );
                      });
                }),
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await context.read<DashboardProvider>().addComment(widget.postModel.postId, controller.text);
                      controller.clear();
                    },
                    icon: const Icon(Icons.send, color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
