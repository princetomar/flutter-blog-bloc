// ignore: implementation_imports
import 'package:fpdart/src/either.dart';
import 'package:sks/core/error/exceptions.dart';
import 'package:sks/core/error/failures.dart';
import 'package:sks/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:sks/core/common/entities/user.dart';
import 'package:sks/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> loginUserwithEmailAndPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await authRemoteDataSource
        .loginUserwithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpUserWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(() async =>
        await authRemoteDataSource.signUpUserWithEmailPassword(
            name: name, email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(
          Failure("User not logged In."),
        );
      } else {
        return right(user);
      }
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}

Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
  try {
    final user = await fn();
    return right(user);
  } on sb.AuthException catch (e) {
    return left(Failure(
      e.message,
    ));
  } on ServerException catch (e) {
    return left(Failure(
      e.message,
    ));
  }
}
