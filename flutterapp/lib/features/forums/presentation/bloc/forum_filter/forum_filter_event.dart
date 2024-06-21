part of 'forum_filter_bloc.dart';

sealed class ForumFilterEvent extends Equatable {
  const ForumFilterEvent();

  @override
  List<Object> get props => [];
}

final class UpdateFilter extends ForumFilterEvent {
  const UpdateFilter();

  @override
  List<Object> get props => [];
}

final class UpdateForums extends ForumFilterEvent {
  final int forumFilter;

  const UpdateForums({this.forumFilter = -1});

  @override
  List<Object> get props => [forumFilter];
}