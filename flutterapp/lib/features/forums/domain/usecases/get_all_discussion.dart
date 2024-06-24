import 'package:dartz/dartz.dart';
import 'package:flutterapp/core/exceptions/failure.dart';
import 'package:flutterapp/core/usecases/search/get_all_discussion.dart';
import 'package:flutterapp/features/forums/domain/entities/discussion_entity.dart';
import 'package:flutterapp/features/forums/domain/repository/discussion_repo.dart';

class GetAllDiscussionCase
    implements
        GetAllDiscussion<List<DiscussionAllEntity>, ParamsGetDiscussionTitle> {
  final DiscussionRepo discussionRepo;

  String title;

  GetAllDiscussionCase({required this.discussionRepo, required this.title});

  @override
  Future<Either<Failure, List<DiscussionAllEntity>>> call(
      ParamsGetDiscussionTitle params) async {
    return await discussionRepo.getAllDiscussion(title);
  }
}
