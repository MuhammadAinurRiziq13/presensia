import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/core/utils/dio_client/dio_client.dart';
import 'package:presensia/presentation/screens/app.dart';
import '../../presentation/screens/login/login.dart';
import '../../presentation/screens/register/register.dart';
import '../../presentation/screens/splash_screen/splash_screen.dart';
import '../../presentation/blocs/register/register_bloc.dart';
import '../../presentation/blocs/login/login_bloc.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_api_datasource.dart';
import '../utils/constants.dart';

class AppRoutes {
  // Instance DioClient yang digunakan di seluruh aplikasi
  static final DioClient dioClient = DioClient(baseUrl: Constants.baseUrl);

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) {
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
        });

      case '/register':
        return MaterialPageRoute(builder: (_) {
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
        });

      case '/home':
        return MaterialPageRoute(builder: (_) => App());

      default:
        return _defaultRoute();
    }
  }

  // Route default untuk menangani route yang tidak ditemukan
  static MaterialPageRoute _defaultRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Route not found'),
        ),
      ),
    );
  }
}
