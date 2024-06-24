part of 'discussion_bloc.dart';

abstract class DiscussionState extends Equatable {
  const DiscussionState();
  @override
  List<Object> get props => [];
}

final class DiscussionLoading extends DiscussionState {}

class DiscussionSuccess extends DiscussionState {
  final List<DiscussionAllEntity> discussions;

  const DiscussionSuccess({this.discussions = const <DiscussionAllEntity>[]});

  @override
  List<Object> get props => [discussions];
}

class DiscussionFailure extends DiscussionState {
  final String message;
  const DiscussionFailure({required this.message});
}
