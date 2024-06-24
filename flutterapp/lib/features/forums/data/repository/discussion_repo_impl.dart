import 'package:dartz/dartz.dart';
import 'package:flutterapp/core/exceptions/error.dart';
import 'package:flutterapp/core/exceptions/failure.dart';
import 'package:flutterapp/features/forums/data/data_sources/discussion_data_source.dart';
import 'package:flutterapp/features/forums/data/models/Discussion_model.dart';
import 'package:flutterapp/features/forums/domain/repository/discussion_repo.dart';

class DiscussionRepoImpl implements DiscussionRepo {
  final DiscussionDataSource discussionDataSource;

  DiscussionRepoImpl({required this.discussionDataSource});

  @override
  Future<Either<Failure, List<DiscussionAllModel>>> getAllDiscussion(
      String title) async {
    try {
      final discussions = await discussionDataSource.getAllDiscussions(title);
      return Right(discussions);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
