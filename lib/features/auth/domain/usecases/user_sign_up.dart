// ignore: implementation_imports
import 'package:fpdart/src/either.dart';
import 'package:sks/core/error/failures.dart';
import 'package:sks/core/usecases/usecase.dart';
import 'package:sks/core/common/entities/user.dart';
import 'package:sks/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements Usecase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpUserWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams(
    this.email,
    this.name,
    this.password,
  );
}
