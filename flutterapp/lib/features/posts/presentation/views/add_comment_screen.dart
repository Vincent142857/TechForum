import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/features/posts/presentation/bloc/comments_bloc.dart';
import 'package:flutterapp/features/posts/presentation/widgets/input_text_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddComment extends StatefulWidget {
  const AddComment({super.key, required this.discussionId});

  final int discussionId;

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  File? image;
  TextEditingController contentController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new post Comment'),
      ),
      body: BlocListener<CommentsBloc, CommentsState>(
        listener: (context, state) {
          if (state is AddCommentLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Comment added successfully',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            );
          } else if (state is AddCommentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Failed to add Comment',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildInputFieldTextArea('Description', contentController),
                ElevatedButton(
                  onPressed: () {
                    // create Comment
                    context.read<CommentsBloc>().add(AddCommentEvent(
                          content: contentController.text,
                          discussionId: widget.discussionId,
                        ));
                    //to home
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Add new',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}