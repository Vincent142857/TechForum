import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/core/storage/storage.dart';
import 'package:flutterapp/features/feed/presentation/views/home_screen.dart';
import 'package:flutterapp/features/members/presentation/views/member_list_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import '../views/feed_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  File? image;
  String username = "Anonymous";

  String? ownerId;
  Future<String> fetchId() async {
    String? ownerId = await Storage().secureStorage.read(key: 'userId');
    return ownerId!;
  }

  @override
  void initState() {
    super.initState();
    fetchId().then((value) {
      setState(() {
        ownerId = value;
      });
    });
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imagePathObject = File(image.path);
      setState(() {
        this.image = imagePathObject;
      });
    } on PlatformException catch (err) {
      print('failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 70,
                ),
                trailing: Column(
                  children: [
                    image != null
                        ? TextButton(
                            onPressed: () {
                              context
                                  .read<AuthBloc>()
                                  .add(ChangeProfPic(image!));
                            },
                            child: const Text('Submit'))
                        : TextButton(
                            onPressed: () => pickImage(),
                            child: const Text('Change Pic')),
                  ],
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      title: Text(ownerId ?? 'Anonymous'),
                      subtitle: InkWell(
                          onTap: () async {
                            String? ownerId = await Storage()
                                .secureStorage
                                .read(key: 'userId');

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  ownerId: ownerId!,
                                ),
                              ),
                            );
                          },
                          child: Text('Profile $ownerId!')),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 0.5,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text('Home'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const ForumsScreen(),
                        //   ),
                        // );
                      },
                      child: const Text('Forums'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MemberListScreen(),
                          ),
                        );
                      },
                      child: const Text('Members'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LoggedOut());
                      },
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}