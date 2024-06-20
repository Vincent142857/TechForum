import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/features/posts/presentation/bloc/comments_bloc.dart';
import 'package:flutterapp/features/posts/presentation/widgets/input_text_widget.dart';
import 'package:flutterapp/features/posts/presentation/widgets/input_widget.dart';

class CreateDiscussion extends StatelessWidget {
  const CreateDiscussion(
      {super.key, required this.forumId, required this.title});

  final int forumId;
  final String title;

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new post discussion'),
      ),
      body: BlocListener<CommentsBloc, CommentsState>(
        listener: (context, state) {
          if (state is CreateDiscussionLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Discussion added successfully',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            );
          } else if (state is CreateDiscussionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Failed to add discussion',
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
                buildInputField('Title', titleController),
                buildInputFieldTextArea('Description', contentController),
                ElevatedButton(
                  onPressed: () {
                    // create discussion
                    context.read<CommentsBloc>().add(AddDiscussionEvent(
                          title: titleController.text,
                          content: contentController.text,
                          forumId: forumId,
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

  Column _inputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.only(bottom: 10.0),
          width: double.infinity,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter $label',
            ),
            controller: controller,
          ),
        ),
      ],
    );
  }

  Column _inputFieldTextArea(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        Container(
          height: 200,
          margin: const EdgeInsets.only(bottom: 10.0),
          width: double.infinity,
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Enter $label',
            ),
            controller: controller,
          ),
        ),
      ],
    );
  }
}