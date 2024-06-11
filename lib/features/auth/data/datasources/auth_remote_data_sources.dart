import 'package:sks/core/error/exceptions.dart';
import 'package:sks/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  // FOR SESSION MANAGEMENT OF USER
  Session? get currentUserSession;

  Future<UserModel> signUpUserWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginUserwithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // 1. Ask for supabase client from the constructor of this class.
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  // TODO: implement currentUserSession
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginUserwithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (response.user == null) {
        throw const ServerException("User is null!");
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentUserSession!.user.email,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpUserWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final response = await supabaseClient.auth
          .signUp(email: email, password: password, data: {
        'name': name,
      });

      if (response.user == null) {
        throw const ServerException("User is null!");
      }

      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentUserSession!.user.email,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        // Go to the profiles table and mention columns to return in the select() and row in the eq()
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );

        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        ); // returning the first because we've already applied
        // the filter to fetch only current/one user data.
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
