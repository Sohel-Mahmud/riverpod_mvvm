import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soptify_mvvm_riverpod/features/auth/model/user_model.dart';
import 'package:soptify_mvvm_riverpod/features/auth/repositories/auth_remote_repository.dart';

part 'auth_viewmodel.g.dart';

/* 
// can be use this way if code generation is not used
class AuthViewmodel extends Notifier { */

@riverpod
class AuthViewmodel extends _$AuthViewmodel {

  final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();

  // build is for creating initial value
  // or initializing any dependencies
  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    // contains the current state of the object
    // also `state = AsyncLoading` is okay
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
        name: name,
        email: email,
        password: password.trim());

    final val = switch (res) {
      Left(value: final l) => l,
      Right(value: final r) => r.toString(),
    };
    print(val);
  }
}
