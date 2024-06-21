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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Forums"),
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
                      pinned: true,
                      floating: true,
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        isScrollable: true, // Cho phép cuộn ngang
                        tabs: state.groups
                            .map((tab) => Tab(text: tab.title))
                            .toList(),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: state.groups
                      .map((tab) => TabViewContent(tab: tab))
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
}

class TabViewContent extends StatelessWidget {
  final ForumGroupEntity tab;

  const TabViewContent({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual tab view content based on `tab`
    return Center(
      child: Text('Content of ${tab.title}'),
    );
  }
}