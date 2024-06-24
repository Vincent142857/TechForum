import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterapp/core/usecases/members/search_memeber.dart';
import 'package:flutterapp/features/members/domain/entities/member_entity.dart';
import 'package:flutterapp/features/members/domain/usecases/search_member_usecase.dart';

import '../../../../core/usecases/members/get_all_member.dart';
import '../../domain/usecases/get_all_memeber.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  //domain usecase
  final GetAllMemberUseCase _getAllMemberUseCase;
  final SearchMemberUseCase _searchMemberUseCase;

  MemberBloc({
    required GetAllMemberUseCase getAllMemberUseCase,
    required SearchMemberUseCase searchMemberUseCase,
  })  : _getAllMemberUseCase = getAllMemberUseCase,
        _searchMemberUseCase = searchMemberUseCase,
        super(MemberInitial()) {
    on<GetMemberEvent>((event, emit) async {
      emit(MemberLoading());
      try {
        await _getAllMemberUseCase.call(NoParams()).then((members) {
          members.fold(
            (l) => emit(const MemberFailure()),
            (member) => emit(MemberSuccess(memberEntity: member)),
          );
        });
      } catch (err) {
        print(err);
      }
    });

    on<SearchMemberEvent>((event, emit) async {
      if (event.query.isEmpty) {}

      try {
        await _searchMemberUseCase
            .call(ParamsSearch(query: event.query))
            .then((members) {
          members.fold(
            (l) => emit(MemberFailure(
              message: 'No member found with query: ${event.query}',
            )),
            (member) => emit(MemberSuccess(memberEntity: member)),
          );
        });
      } catch (err) {
        print(err);
      }
    });
  }
}