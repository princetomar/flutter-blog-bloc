import 'package:fpdart/fpdart.dart';
import 'package:sks/core/error/failures.dart';
import 'package:sks/core/usecases/usecase.dart';
import 'package:sks/core/common/entities/user.dart';
import 'package:sks/features/auth/domain/repository/auth_repository.dart';

class UserSignIn implements Usecase<User, UserSignInParams> {
  final AuthRepository authRepository;
  UserSignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await authRepository.loginUserwithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({required this.email, required this.password});
}
