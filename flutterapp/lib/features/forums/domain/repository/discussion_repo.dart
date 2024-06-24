import 'package:dartz/dartz.dart';
import 'package:flutterapp/core/exceptions/failure.dart';
import 'package:flutterapp/features/forums/domain/entities/discussion_entity.dart';

abstract class DiscussionRepo {
  Future<Either<Failure, List<DiscussionAllEntity>>> getAllDiscussion(
      String title);
}
