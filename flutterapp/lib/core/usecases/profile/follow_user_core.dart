import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterapp/core/exceptions/failure.dart';

abstract class FollowUserCoreParams<Type, ParamsFollowUserCore> {
  Future<Either<Failure, Type>> call(ParamsFollowUserCore params);
}

class ParamsFollowUser extends Equatable {
  final int followerUserId;
  final int followingUserId;

  const ParamsFollowUser(
      {required this.followerUserId, required this.followingUserId});

  @override
  List<Object?> get props => [followerUserId, followingUserId];
}