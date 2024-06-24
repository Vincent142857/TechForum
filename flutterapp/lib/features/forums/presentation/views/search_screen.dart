import 'package:flutter/material.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('All Discussion'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          body: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                // children: [
                //   SizedBox(
                //     height: 700,
                //     child: BlocBuilder<ForumBloc, ForumState>(
                //       builder: (context, state) {
                //         if (state is ForumInitial) {
                //           return const Center(
                //             child: Text("EMPTY"),
                //           );
                //         } else if (state is ForumLoading) {
                //           return const Center(
                //             child: CircularProgressIndicator(),
                //           );
                //         } else if (state is ForumSuccess) {
                //           return GridView.builder(
                //             gridDelegate:
                //                 const SliverGridDelegateWithFixedCrossAxisCount(
                //               crossAxisCount: 2,
                //               crossAxisSpacing: 4.0,
                //               mainAxisSpacing: 4.0,
                //             ),
                //             itemCount: state.forumEntity.length,
                //             itemBuilder: (context, index) =>
                //                 ForumItem(forum: state.forumEntity[index]),
                //           );
                //         } else if (state is ForumFailure) {
                //           return const Text('error connection');
                //         } else {
                //           return const Text('default');
                //         }
                //       },
                //     ),
                //   ),
                // ],
                ),
          )),
    );
  }
}
