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

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late int _currentTabIndex = 0;

  static const List<ForumGroupEntity> groups = [
    ForumGroupEntity(id: 1, title: "DEV", color: "red"),
    ForumGroupEntity(id: 2, title: "Game", color: "green"),
    ForumGroupEntity(id: 3, title: "Financial", color: "blue"),
    ForumGroupEntity(id: 4, title: "Marketing", color: "grey"),
  ];
  // //

  @override
  void initState() {
    tabController = TabController(length: groups.length + 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(tabController.index == 0
              ? "All"
              : (groups[tabController.index - 1].title ?? "All")),
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
          bottom: TabBar(
              onTap: (tabIndex) {
                setState(() {
                  _currentTabIndex = tabIndex;
                });
                if (tabIndex == 0) {
                  BlocProvider.of<ForumFilterBloc>(context).add(
                    const UpdateForums(
                      forumFilter: -1,
                    ),
                  );
                } else {
                  BlocProvider.of<ForumFilterBloc>(context).add(
                    UpdateForums(
                      forumFilter: groups[tabIndex - 1].id ?? -1,
                    ),
                  );
                }
              },
              controller: tabController,
              tabs: [
                const TabItem(title: "All"),
                TabItem(title: groups[0].title ?? "G1"),
                TabItem(title: groups[1].title ?? "G2"),
                TabItem(title: groups[2].title ?? "G3"),
                TabItem(title: groups[3].title ?? "G4"),
              ]),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _toForumGroup(tabController, "All"),
            _toForumGroup(tabController, groups[0].title ?? "G1"),
            _toForumGroup(tabController, groups[1].title ?? "G2"),
            _toForumGroup(tabController, groups[2].title ?? "G3"),
            _toForumGroup(tabController, groups[3].title ?? "G4"),
          ],
        ),
      ),
    );
  }

//-------------------End of HomePage-------------------
  Widget _buildHomePage(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupLoading) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Home Page'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ));
        } else if (state is GroupSuccess && state.groups.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home Page'),
            ),
            body: const Center(
              child: Text('No groups found'),
            ),
          );
        } else if (state is GroupSuccess) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home Page'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: Theme.of(context).iconTheme,
              actions: [
                Consumer<ThemeService>(
                    builder: (context, ThemeService theme, _) {
                  return IconButton(
                      onPressed: () {
                        theme.toggleTheme();
                      },
                      icon: Icon(theme.darkTheme!
                          ? Icons.sunny
                          : CupertinoIcons.moon_stars));
                })
              ],
              bottom: TabBar(
                  onTap: (tabIndex) {
                    setState(() {
                      _currentTabIndex = tabIndex;
                    });
                    if (tabIndex == 0) {
                      BlocProvider.of<ForumFilterBloc>(context).add(
                        const UpdateForums(
                          forumFilter: -1,
                        ),
                      );
                    } else {
                      BlocProvider.of<ForumFilterBloc>(context).add(
                        UpdateForums(
                          forumFilter: state.groups[tabIndex - 1].id ?? -1,
                        ),
                      );
                    }
                  },
                  controller: tabController,
                  tabs: [
                    const TabItem(title: "All"),
                    for (var group in state.groups)
                      TabItem(title: group.title ?? 'Group'),
                  ]),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                _toForumGroup(tabController, "All"),
                for (var group in state.groups)
                  _toForumGroup(tabController, group.title ?? 'Group'),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home Page'),
            ),
            body: const Text('Something went wrong'),
          );
        }
      },
    );
  }

  //-------------------End of TabBar-------------------

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
              const Text('No discussions found'),
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
    );
  }

  Container _discussionItemCard(
      BuildContext context, DiscussionEntity discussion, int? forumId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
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
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      '#${discussion.discussionTitle}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
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