import 'package:get_it/get_it.dart';
import 'package:sks/core/secrets/app_secrets.dart';
import 'package:sks/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:sks/features/auth/data/repository/auth_repository_impl.dart';
import 'package:sks/features/auth/domain/repository/auth_repository.dart';
import 'package:sks/features/auth/domain/usecases/current_user.dart';
import 'package:sks/features/auth/domain/usecases/user_sign_in.dart';
import 'package:sks/features/auth/domain/usecases/user_sign_up.dart';
import 'package:sks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  // 1. Initialize the Supabase
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseURL,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  // 2. Regiter the Dependencies
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  // We need to define the type, because we're registering AuthRemoteDataSourceImpl
  // and we need to return the type of AuthRemoteDataSource
  // ignore: avoid_single_cascade_in_expression_statements

  serviceLocator
    // DATA
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // REPOSITORY
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // USECASES
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignIn(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // BLOC
    ..

        // register the bloc, and we want to have the same state throughout the process,
        // so we're using registerLazySingleton here
        registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        currentUser: serviceLocator(),
      ),
    );
}
