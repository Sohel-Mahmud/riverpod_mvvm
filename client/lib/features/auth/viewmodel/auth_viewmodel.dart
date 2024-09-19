import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soptify_mvvm_riverpod/features/auth/model/user_model.dart';
import 'package:soptify_mvvm_riverpod/features/auth/repositories/auth_local_repository.dart';
import 'package:soptify_mvvm_riverpod/features/auth/repositories/auth_remote_repository.dart';

import '../../../core/providers/current_user_notifier.dart';

part 'auth_viewmodel.g.dart';

/* 
// can be use this way if code generation is not used
class AuthViewmodel extends Notifier { */

@Riverpod(keepAlive: true)
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  // build is for creating initial value
  // or initializing any dependencies
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);

    return null;
  }

  Future<void> initSharedPrefs() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    // contains the current state of the object
    // also `state = AsyncLoading` is okay
    state = const AsyncValue.loading();

    //future delay 2 sec
    await Future.delayed(const Duration(seconds: 1));

    final res = await _authRemoteRepository.signup(
        name: name, email: email, password: password.trim());

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    // contains the current state of the object
    // also `state = AsyncLoading` is okay
    state = const AsyncValue.loading();

    //future delay 2 sec
    await Future.delayed(const Duration(seconds: 1));

    final res = await _authRemoteRepository.login(
        email: email, password: password.trim());

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _loginSuccess(r),
    };
    print(val);
  }

  // method is saparated cz swith (res) not allows block of code
  AsyncValue<UserModel>? _loginSuccess(UserModel userModel) {
    _authLocalRepository.setToken(userModel.token);
    _currentUserNotifier.addUser(userModel);
    return state = AsyncValue.data(userModel);
  }

  Future<UserModel?> getData() async {
    //state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();

    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUserData(token);
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
            l.message,
            StackTrace.current,
          ),
        Right(value: final r) => _getDataSuccess(r),
      };

      return val.value;
    }

    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

}
