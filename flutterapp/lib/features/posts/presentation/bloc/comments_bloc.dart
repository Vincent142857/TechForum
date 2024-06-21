import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterapp/core/storage/storage.dart';
import 'package:flutterapp/core/usecases/posts/create_comment.dart';
import 'package:flutterapp/core/usecases/posts/create_discussion.dart';
import 'package:flutterapp/core/usecases/posts/get_all_comment.dart';
import 'package:flutterapp/features/posts/domain/entities/comment_entity.dart';
import 'package:flutterapp/features/posts/domain/usecases/create_comment.dart';
import 'package:flutterapp/features/posts/domain/usecases/create_discussion.dart';
import 'package:flutterapp/features/posts/domain/usecases/get_comments_by.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  //domain usecase
  final GetAllCommentsUseCase _getAllCommentsUseCase;

  final CreateDiscussionUseCase _createDiscussionUseCase;

  final CreateCommentUseCase _createCommentUseCase;

  CommentsBloc(
      {required GetAllCommentsUseCase getAllCommentsUseCase,
      required CreateDiscussionUseCase createDiscussionUseCase,
      required CreateCommentUseCase createCommentUseCase})
      : _getAllCommentsUseCase = getAllCommentsUseCase,
        _createDiscussionUseCase = createDiscussionUseCase,
        _createCommentUseCase = createCommentUseCase,
        super(CommentsLoading()) {
    on<LoadCommentsEvent>((event, emit) async {
      final discussionId = event.discussionId;
      await _getAllCommentsUseCase
          .call(ParamsCommentsBy(discussionId: discussionId))
          .then((comments) {
        comments.fold(
          (failure) => emit(CommentsError()),
          (comments) => emit(CommentsLoaded(
            comments: comments,
            discussionId: event.discussionId,
          )),
        );
      });
    });
    on<AddDiscussionEvent>((event, emit) async {
      emit(CreateDiscussionLoading());
      await _createDiscussionUseCase
          .call(ParamsDiscussion(
        title: event.title,
        content: event.content,
        forumId: event.forumId,
        author: await _getUserId(),
      ))
          .then((discussion) {
        discussion.fold(
          (failure) => emit(CreateDiscussionFailure()),
          (discussion) => emit(CreateDiscussionLoaded()),
        );
      });
    });
    on<AddCommentEvent>((event, emit) async {
      emit(AddCommentLoading());
      await _createCommentUseCase
          .call(ParamsComment(
        content: event.content,
        discussionId: event.discussionId,
        author: await _getUserId(),
      ))
          .then((comment) {
        comment.fold(
          (failure) => emit(AddCommentFailure()),
          (comment) => emit(AddCommentLoaded()),
        );
      });
    });
  }

  Future<String> _getUserId() async {
    return await Storage().secureStorage.read(key: 'userId') ?? '';
  }
}