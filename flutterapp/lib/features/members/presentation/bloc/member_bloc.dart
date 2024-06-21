import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterapp/features/members/domain/entities/member_entity.dart';

import '../../../../core/usecases/members/get_all_member.dart';
import '../../domain/usecases/get_all_memeber.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  //domain usecase
  final GetAllMemberUseCase _getAllMemberUseCase;

  MemberBloc({required GetAllMemberUseCase getAllMemberUseCase})
      : _getAllMemberUseCase = getAllMemberUseCase,
        super(MemberInitial()) {
    on<GetMemberEvent>((event, emit) async {
      emit(MemberLoading());
      try {
        await _getAllMemberUseCase.call(NoParams()).then((members) {
          members.fold(
            (l) => emit(MemberFailure()),
            (member) => emit(MemberSuccess(memberEntity: member)),
          );
        });
      } catch (err) {
        print(err);
      }
    });
  }
}