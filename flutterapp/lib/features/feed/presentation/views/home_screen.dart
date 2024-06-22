import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/features/feed/presentation/widgets/app_drawer_widget.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text("Tech Forums"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: Theme.of(context).iconTheme,
          actions: [
            Consumer<ThemeService>(builder: (context, ThemeService theme, _) {
              return IconButton(
                  onPressed: () {
                    theme.toggleTheme();
                  },
                  icon: Icon(theme.darkTheme!
                      ? Icons.sunny
                      : CupertinoIcons.moon_stars));
            })
          ],
        ),
        body: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
          if (state is GroupLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GroupSuccess) {
            return DefaultTabController(
              length: state.groups.length,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 100.0,
                      pinned: true,
                      floating: false,
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        onTap: (tabIndex) {
                          if (tabIndex == 0) {
                            BlocProvider.of<ForumFilterBloc>(context).add(
                              const UpdateForums(
                                forumFilter: -1,
                              ),
                            );
                          } else {
                            BlocProvider.of<ForumFilterBloc>(context).add(
                              UpdateForums(
                                forumFilter: state.groups[tabIndex].id ?? 0,
                              ),
                            );
                          }
                        },
                        isScrollable: true, // Cho phép cuộn ngang
                        tabs: state.groups
                            .map((tab) =>
                                TabItem(title: tab.title, color: tab.color))
                            .toList(),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: state.groups
                      .map((tab) => _toForumGroup(tab.title))
                      .toList(),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        }),
      ),
    );
  }

  //----------------------------------------
  BlocConsumer<ForumFilterBloc, ForumFilterState> _toForumGroup(String title) {
    return BlocConsumer<ForumFilterBloc, ForumFilterState>(
      listener: (context, state) {
        if (state is ForumFilterLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Forums loaded'),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
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
              const Text('You are the first to post a discussion.'),
            ],
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
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
    );
  }

  Container _discussionItemCard(
      BuildContext context, DiscussionEntity discussion, int? forumId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      child: SingleChildScrollView(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _buildImage(discussion),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            context.read<CommentsBloc>().add(LoadCommentsEvent(
                                  discussionId: discussion.discussionId!,
                                ));
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  discussionId: discussion.discussionId ?? 1,
                                  discussionTitle: discussion.discussionTitle ??
                                      'Discussion',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '#${discussion.discussionTitle}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  buildCreatedAt(discussion),
                  const SizedBox(
                    height: 8,
                  ),
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
        fontSize: 12.0,
      ),
    );
  }

  Widget _buildImage(DiscussionEntity discussion) {
    return buildAvatar(
      imageUrl: discussion.imageUrl ?? '',
      avatar: discussion.avatar ?? '',
      width: 42,
      height: 42,
    );
  }
}

class TabViewContent extends StatelessWidget {
  final ForumGroupEntity tab;

  const TabViewContent({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual tab view content based on `tab`
    return _toForumGroup(tab.title);
  }

  BlocConsumer<ForumFilterBloc, ForumFilterState> _toForumGroup(String title) {
    return BlocConsumer<ForumFilterBloc, ForumFilterState>(
      listener: (context, state) {
        if (state is ForumFilterLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Forums loaded'),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
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
              const Text('You are the first to post a discussion.'),
            ],
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
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
    );
  }

  Container _discussionItemCard(
      BuildContext context, DiscussionEntity discussion, int? forumId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      child: SingleChildScrollView(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _buildImage(discussion),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            context.read<CommentsBloc>().add(LoadCommentsEvent(
                                  discussionId: discussion.discussionId!,
                                ));
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                  discussionId: discussion.discussionId ?? 1,
                                  discussionTitle: discussion.discussionTitle ??
                                      'Discussion',
                                ),
                              ),
                            );
                          },
                          child: Text(
                            '#${discussion.discussionTitle}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  buildCreatedAt(discussion),
                  const SizedBox(
                    height: 8,
                  ),
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
        fontSize: 12.0,
      ),
    );
  }

  Widget _buildImage(DiscussionEntity discussion) {
    return buildAvatar(
      imageUrl: discussion.imageUrl ?? '',
      avatar: discussion.avatar ?? '',
      width: 42,
      height: 42,
    );
  }
}