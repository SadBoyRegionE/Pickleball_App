import 'package:auth0_flutter/auth0_flutter.dart';


class AuthService {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;

  Auth0 auth0 = Auth0('dev-6sspiyjwhjhai7vg.us.auth0.com', 'XT7dfVLYJrJS23f9Ivw1PlCk4VxPWTLx');
  UserProfile? profile;

  AuthService._internal();
  Future<UserProfile?> login() async {
    final credentials = await auth0.webAuthentication().login(
      audience: 'https://localhost:7145/',
      redirectUrl: 'untitled1://dev-6sspiyjwhjhai7vg.us.auth0.com/android/com.example.untitled1/callback'
    );
    profile = credentials.user;
    return profile;
  }

  Future signup() async {
    final credentials = await auth0.webAuthentication().login(
      parameters: {
        'screen_hint': 'signup',
      },
      redirectUrl: 'untitled1://dev-6sspiyjwhjhai7vg.us.auth0.com/android/com.example.untitled1/callback', // Thêm redirectUrl
    );
    profile = credentials.user;
    return profile;
  }

  Future<void> logout() async {
     await auth0.webAuthentication().logout( returnTo :'untitled1://dev-6sspiyjwhjhai7vg.us.auth0.com/android/com.example.untitled1/callback');
    profile = null;
  }

  Future init() async {
    final isLoggedIn = await auth0.credentialsManager.hasValidCredentials();
    if (isLoggedIn) {
      final credentials = await auth0.credentialsManager.credentials();
      profile = credentials.user;
    }
    return profile;
  }

    Future<String> getAccessToken() async {
      if (await auth0.credentialsManager.hasValidCredentials()) {
        final credentials = await auth0.credentialsManager.credentials();
        return credentials.accessToken;
      }
      throw Exception('Not signed in');
    }

}