import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterapp/core/storage/storage.dart';
import 'package:flutterapp/core/usecases/profile/get_user_pro.dart';
import 'package:flutterapp/features/profile/domain/entities/user_pro_entity.dart';
import 'package:flutterapp/features/profile/domain/usecases/get_user_pro.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  //domain usecase
  final GetUserProUseCase _getUserProUseCase;

  ProfileBloc({required GetUserProUseCase getUserProUseCase})
      : _getUserProUseCase = getUserProUseCase,
        super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await _getUserProUseCase
          .call(ParamsGetUserPro(username: event.username));

      result.fold((failure) => emit(ProfileError()),
          (userPro) => emit(ProfileLoaded(userPro: userPro)));
    });
    on<ProfileStartEvent>((event, emit) async {
      emit(ProfileLoading());
      String username = await _getUserId();
      final result =
          await _getUserProUseCase.call(ParamsGetUserPro(username: username));
      result.fold((failure) => emit(ProfileError()),
          (userPro) => emit(ProfileLoaded(userPro: userPro)));
    });
  }

  Future<String> _getUserId() async {
    return await Storage().secureStorage.read(key: 'userId') ?? '';
  }
}
