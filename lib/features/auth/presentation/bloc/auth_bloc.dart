import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sks/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:sks/core/usecases/usecase.dart';
import 'package:sks/core/common/entities/user.dart';
import 'package:sks/features/auth/domain/usecases/current_user.dart';
import 'package:sks/features/auth/domain/usecases/user_sign_in.dart';
import 'package:sks/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Use case for User sign up
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserSignIn userSignIn,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    // Catch the AuthSignUp event, so that whenever it's received - The sign up process begins
    on<AuthSignUp>(_onAuthSignUp);
    // On Signing In
    on<AuthSignIn>(_onAuthSignIn);

    on<AuthIsUserSignedIn>(_isUserSignedIn);
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // 2. Call the usecases for SignUp from cons
    final res = await _userSignUp(UserSignUpParams(
      event.email,
      event.name,
      event.password,
    ));

    // Controll / Handle the success/failure
    res.fold((l) => emit(AuthFailure(message: l.message)),
        (user) => emit(AuthSuccess(user: user)));
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _userSignIn(
        UserSignInParams(email: event.email, password: event.password));

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  void _isUserSignedIn(
      AuthIsUserSignedIn event, Emitter<AuthState> emit) async {
    final result = await _currentUser(NoParams());

    result.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) {
        print("IS USER SIGNED IN : true");
        print(r);
        emit(AuthSuccess(user: r));
        _emitAuthSuccess(r, emit);
      },
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emitter) {
    // Update the user using cubit
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
