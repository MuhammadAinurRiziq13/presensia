import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/presentation/screens/login/login.dart';
import 'package:presensia/presentation/screens/register/register.dart';
import 'package:presensia/presentation/screens/splash_screen/splash_screen.dart';
import 'package:presensia/presentation/screens/app.dart';
import 'package:presensia/domain/usecases/register_usecase.dart';
import 'package:presensia/domain/usecases/login_usecase.dart';
import 'package:presensia/data/repositories/auth_repository_impl.dart';
import 'package:presensia/data/datasources/auth_api_datasource.dart';
import 'package:presensia/core/utils/dio_client/dio_client.dart';
import 'package:presensia/core/utils/constants.dart';
import 'package:presensia/presentation/blocs/register/register_bloc.dart';
import 'package:presensia/presentation/blocs/login/login_bloc.dart';

class AppRoutes {
  static final DioClient dioClient = DioClient(baseUrl: Constants.baseUrl);

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Route SplashScreen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Route Login
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final authApiDataSource = AuthApiDataSource(dioClient);
          final authRepositoryImpl = AuthRepositoryImpl(authApiDataSource);
          final loginUseCase = LoginUseCase(authRepositoryImpl);

          return RepositoryProvider(
            create: (_) => loginUseCase,
            child: BlocProvider(
              create: (_) => LoginBloc(loginUseCase),
              child: const LoginPage(),
            ),
          );
        },
      ),

      // Route Register
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final authApiDataSource = AuthApiDataSource(dioClient);
          final authRepositoryImpl = AuthRepositoryImpl(authApiDataSource);
          final registerUseCase = RegisterUseCase(authRepositoryImpl);

          return RepositoryProvider(
            create: (_) => registerUseCase,
            child: BlocProvider(
              create: (_) => RegisterBloc(registerUseCase),
              child: const RegisterPage(),
            ),
          );
        },
      ),

      // Route Home
      GoRoute(
        path: '/home',
        builder: (context, state) => const App(),
      ),
    ],
    errorBuilder: (context, state) {
      return const Scaffold(
        body: Center(
          child: Text('Route not found'),
        ),
      );
    },
  );
}
