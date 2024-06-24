part of 'discussion_bloc.dart';

abstract class DiscussionEvent extends Equatable {
  const DiscussionEvent();
  @override
  List<Object> get props => [];
}

class GetAllDiscussionsEvent extends DiscussionEvent {
  final List<DiscussionAllEntity> discussions;

  const GetAllDiscussionsEvent(
      {this.discussions = const <DiscussionAllEntity>[]});

  @override
  List<Object> get props => [discussions];
}

class GetDiscussionsComplete extends DiscussionEvent {}
