import 'package:flutter/material.dart';
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
                          title: Text(comment.text),
                          trailing: Text(comment.commentAt.toString()),
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
