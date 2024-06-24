part of 'member_bloc.dart';

enum MemberEventStatus { initial, loading, success, failure }

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberSuccess extends MemberState {
  final List<MemberEntity> memberEntity;

  const MemberSuccess({required this.memberEntity});
}

class MemberFailure extends MemberState {
  final String message;

  const MemberFailure({this.message = ''});

  @override
  List<Object> get props => [message];
}