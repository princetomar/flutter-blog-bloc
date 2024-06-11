// ignore: implementation_imports
import 'package:fpdart/fpdart.dart';
import 'package:sks/core/error/failures.dart';
import 'package:sks/core/usecases/usecase.dart';
import 'package:sks/core/common/entities/user.dart';
import 'package:sks/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
