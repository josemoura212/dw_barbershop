import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'user_register_providers.dart';

part 'user_register_vm.g.dart';

enum UserRegisterAdmStateStatus {
  inital,
  success,
  error,
}

@riverpod
class UserRegisterVm extends _$UserRegisterVm {
  @override
  UserRegisterAdmStateStatus build() => UserRegisterAdmStateStatus.inital;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final userRegisterAdmService = ref.watch(userRegisterAdmServiceProvider);

    final userData = (
      name: name,
      email: email,
      password: password,
    );

    final registerResult =
        await userRegisterAdmService.execute(userData).asyncLoader();

    switch (registerResult) {
      case Success():
        ref.invalidate(getMeProvider);
        state = UserRegisterAdmStateStatus.success;
      case Failure():
        state = UserRegisterAdmStateStatus.error;
    }
  }
}
