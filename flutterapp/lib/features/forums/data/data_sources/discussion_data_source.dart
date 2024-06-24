import 'dart:convert';

import 'package:flutterapp/core/network/api_urls.dart';
import 'package:flutterapp/core/network/session.dart';
import 'package:flutterapp/features/forums/data/models/Discussion_model.dart';

import '../../../../core/exceptions/error.dart';
import 'package:http/http.dart' as http;

abstract class DiscussionDataSource {
  Future<List<DiscussionAllModel>> getAllDiscussions(String title);
}

const uri = '${ApiUrls.API_BASE_URL}/mobile/discussions';

class DiscussionDataSourceImpl implements DiscussionDataSource {
  final NetworkService client;

  DiscussionDataSourceImpl({required this.client});

  @override
  Future<List<DiscussionAllModel>> getAllDiscussions(String title) async {
    List<DiscussionAllModel> discussions = [];
    try {
      http.Response res = await client.get('$uri/all/$title');
      List jsonResponse = json.decode(res.body);
      if (res.statusCode == 200) {
        discussions =
            jsonResponse.map((e) => DiscussionAllModel.fromJson(e)).toList();
      } else {
        throw ServerException('Error getAllDiscussions');
      }
    } catch (err) {
      print(err.toString());
      throw ServerException(err.toString());
    }
    return discussions;
  }
}
