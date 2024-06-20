import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/features/feed/presentation/widgets/avatar_widget.dart';
import 'package:flutterapp/features/feed/presentation/widgets/tab_item_widget.dart';
import 'package:flutterapp/features/forums/domain/entities/forum_entity.dart';
import 'package:flutterapp/features/forums/domain/entities/forum_group_entity.dart';
import 'package:flutterapp/features/forums/presentation/bloc/forum_filter/forum_filter_bloc.dart';
import 'package:flutterapp/features/forums/presentation/bloc/group_bloc/group_bloc.dart';
import 'package:flutterapp/features/posts/presentation/bloc/comments_bloc.dart';
import 'package:flutterapp/features/posts/presentation/views/comments_screen.dart';
import 'package:flutterapp/features/posts/presentation/views/create_discussion.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/theme_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          );
        } else if (state is GroupSuccess && state.groups.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No groups found'),
          );
        } else if (state is GroupSuccess) {
          return const Center(child: Text('Success'));
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }

//-------------------End of HomeScreen-------------------
  BlocConsumer<ForumFilterBloc, ForumFilterState> _toForumGroup(
      TabController tabController, String title) {
    return BlocConsumer<ForumFilterBloc, ForumFilterState>(
      listener: (context, state) {
        if (state is ForumFilterLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Forums $title loaded'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ForumFilterLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ForumFilterLoaded && state.forums.isEmpty) {
          return const Center(
            child: Text('No forums found'),
          );
        } else if (state is ForumFilterLoaded) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.forums.length,
                itemBuilder: (context, index) {
                  return _forumItemCard(context, state.forums[index]);
                }),
          );
        } else {
          return const Text('Something went wrong');
        }
      },
    );
  }

  Container _forumItemCard(BuildContext context, ForumEntity forum) {
    if (forum.discussions.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(forum.title)?.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateDiscussion(
                              forumId: forum.id ?? 1,
                              title: forum.title ?? 'Discussion',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_circle_sharp),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text('No discussions found'),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(forum.title)?.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateDiscussion(
                            forumId: forum.id ?? 1,
                            title: forum.title ?? 'Discussion',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_sharp),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              //list of discussions
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: forum.discussions.length,
                  itemBuilder: (context, index) {
                    return _discussionItemCard(
                        context, forum.discussions[index], forum.id);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Container _discussionItemCard(
      BuildContext context, DiscussionEntity discussion, int? forumId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildImage(discussion),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          '${discussion.discussionTitle}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CommentsBloc>().add(LoadCommentsEvent(
                                discussionId: discussion.discussionId!,
                              ));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                discussionId: discussion.discussionId ?? 1,
                                discussionTitle:
                                    discussion.discussionTitle ?? 'Discussion',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  buildCreatedAt(discussion),
                  //list of discussions
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCreatedAt(DiscussionEntity discussion) {
    DateTime createdAt = discussion.createdAt ?? DateTime.now();
    String name = discussion.name ?? discussion.username ?? "Anonymous";
    return Text(
      '$name created at: ${DateFormat('dd-MM-yyyy HH:mm').format(createdAt)}',
      style: const TextStyle(
        fontSize: 14.0,
      ),
    );
  }

  Widget _buildImage(DiscussionEntity discussion) {
    return buildAvatar(
      imageUrl: discussion.imageUrl,
      avatar: discussion.avatar,
      width: 50,
      height: 50,
    );
  }
}