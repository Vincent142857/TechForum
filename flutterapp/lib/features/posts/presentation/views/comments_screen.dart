import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutterapp/features/feed/presentation/widgets/avatar_widget.dart';
import 'package:flutterapp/features/feed/presentation/widgets/build_datetime.dart';
import 'package:flutterapp/features/posts/domain/entities/comment_entity.dart';
import 'package:flutterapp/features/posts/presentation/bloc/comments_bloc.dart';
import 'package:flutterapp/features/posts/presentation/views/add_comment_screen.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen(
      {super.key, required this.discussionTitle, required this.discussionId});

  final String discussionTitle;
  final int discussionId;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  String get title => widget.discussionTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 700,
              child: BlocBuilder<CommentsBloc, CommentsState>(
                builder: (context, state) {
                  if (state is CommentsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is CommentsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.comments.length,
                        itemBuilder: (context, index) =>
                            commentItem(context, state.comments[index]),
                      ),
                    );
                  } else if (state is CommentsError) {
                    return const Center(child: Text('Error connection'));
                  } else {
                    return const Center(child: Text('EMPTY'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card commentItem(BuildContext context, CommentEntity comment) {
    if (comment.hidden) {
      return const Card(
        child: Center(
          child: Text('Comment is hidden'),
        ),
      );
    }
    return Card(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: _buildImage(comment),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.author.username,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    buildCreatedAt("", comment.createdAt),
                  ],
                ),
              ],
            ),
            Container(
              height: 1,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: HtmlWidget(comment.content),
            ),
            SizedBox(
              height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border_sharp)),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddComment(
                              discussionId: widget.discussionId,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        // bookmarks
                      },
                      icon: const Icon(Icons.bookmark_border),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(CommentEntity comment) {
    String imagePath = comment.author.imageUrl ??
        'https://lh3.googleusercontent.com/a/ACg8ocIKA_Jkp2pWe0wuRjRJvAGJ0_tdjLSK2iBDmIVGTjRAe6B6EJDW=s96-c';
    return buildAvatar(
      imagePath: imagePath,
      width: 42,
      height: 42,
    );
  }
}