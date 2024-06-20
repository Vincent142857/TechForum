import 'dart:convert';
import 'dart:io';
import 'package:flutterapp/core/network/api_urls.dart';
import 'package:http/http.dart' as http;

import 'package:flutterapp/core/exceptions/error.dart';
import 'package:flutterapp/core/network/session.dart';

import '../models/comment_model.dart';

abstract class DiscussionDataSource {
  //create a new discussion
  Future<String?> createDiscussion(
      String title, String content, int forumId, String author);

  //create  a new comment
  Future<CommentModel?> createComment(
      String content, int discussionId, File? imageURL);

  //get all Comments
  Future<List<CommentModel>> getAllCommentsBy(int discussionId);
}

const uri = '${ApiUrls.API_BASE_URL}/mobile/forum';

class DiscussionDataSourceImpl implements DiscussionDataSource {
  final NetworkService client;

  DiscussionDataSourceImpl({required this.client});

  @override
  Future<List<CommentModel>> getAllCommentsBy(int id) async {
    List<CommentModel> comments = [];
    try {
      http.Response res = await client.get('$uri/discussions/$id');
      List jsonResponse = json.decode(res.body);
      print(res.body);
      if (res.statusCode == 200) {
        comments = jsonResponse.map((e) => CommentModel.fromJson(e)).toList();
      } else {
        throw ServerException('Error getAllCommentsBy');
      }
    } catch (err) {
      print('Error getAllCommentsBy: ${err.toString()}');
      throw ServerException(err.toString());
    }
    return comments;
  }

  @override
  Future<String?> createDiscussion(
      String title, String content, int forumId, String author) async {
    try {
      http.Response res = await client.post('$uri/discussions/add', {
        'title': title,
        'content': content,
        'forumId': forumId,
        'author': author
      });
      List jsonResponse = json.decode(res.body);
      print(res.body);
      if (res.statusCode == 200) {
        return res.body;
      }
    } catch (err) {
      print('Error createDiscussion: ${err.toString()}');
      throw ServerException(err.toString());
    }
    return null;
  }

  @override
  Future<CommentModel?> createComment(
      String content, int discussionId, File? imageURL) async {
    try {
      http.Response res = await client.post(
          '$uri/discussions/$discussionId/comments',
          {'content': content, 'discussionId': discussionId.toString()});
      Map jsonResponse = json.decode(res.body);
      print(res.body);
      if (res.statusCode == 200) {
        return CommentModel.fromJson(jsonResponse);
      }
    } catch (err) {
      print('Error createComment: ${err.toString()}');
      throw ServerException(err.toString());
    }
    return null;
  }
}