import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/domain/usecases/update_waktu_keluar_usecase.dart';
import 'package:presensia/data/repositories/history_repository_impl.dart';
import 'package:presensia/data/repositories/auth_repository_impl.dart';
import 'package:presensia/data/repositories/home_repository_impl.dart';
import 'package:presensia/data/datasources/history_api_datasource.dart';
import 'package:presensia/data/datasources/auth_api_datasource.dart';
import 'package:presensia/data/datasources/home_api_datasource.dart';
import 'package:presensia/presentation/screens/home/home_page.dart';
import 'package:presensia/presentation/screens/login/login.dart';
import 'package:presensia/presentation/screens/register/register.dart';
import 'package:presensia/presentation/screens/splash_screen/splash_screen.dart';
import 'package:presensia/presentation/screens/profile/profile_page.dart';
import 'package:presensia/presentation/screens/permit/permit_page.dart';
import 'package:presensia/presentation/screens/history/history_page.dart';
import 'package:presensia/presentation/screens/presensi/presensi_page.dart';
import 'package:presensia/presentation/screens/app.dart';
import 'package:presensia/core/utils/dio_client/dio_client.dart';
import 'package:presensia/core/utils/constants.dart';
import 'package:presensia/presentation/blocs/register/register_bloc.dart';
import 'package:presensia/presentation/blocs/login/login_bloc.dart';
import 'package:presensia/presentation/blocs/history/history_bloc.dart';
import 'package:presensia/presentation/blocs/home/home_bloc.dart';
import 'package:presensia/domain/usecases/history_usecase.dart';
import 'package:presensia/domain/usecases/register_usecase.dart';
import 'package:presensia/domain/usecases/login_usecase.dart';
import 'package:presensia/domain/usecases/get_today_attendance_usecase.dart';
import 'package:presensia/domain/usecases/get_user_usecase.dart';
import 'package:presensia/domain/usecases/get_quota_usecase.dart';
import 'package:presensia/domain/usecases/store_presensi_usecase.dart';
import 'package:presensia/data/repositories/presensi_repository_impl.dart';
import 'package:presensia/data/datasources/presensi_api_datasource.dart';
import 'package:presensia/presentation/blocs/presensi/presensi_bloc.dart';

class AppRoutes {
  static final DioClient dioClient = DioClient(baseUrl: Constants.baseUrl);

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // SplashScreen Route
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Login Route
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

      // Register Route
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

      // Home Route
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final attendanceApiDataSource = AttendanceApiDataSource(dioClient);
          final attendanceRepository =
              AttendanceRepositoryImpl(attendanceApiDataSource);
          final getTodaysAttendanceUseCase =
              GetTodaysAttendanceUseCase(attendanceRepository);
          final getUserUseCase = GetUserUseCase(attendanceRepository);
          final getQuotaUseCase =
              GetRemainingQuotaUseCase(attendanceRepository);
          final updateWaktuKeluarUseCase =
              UpdateWaktuKeluarUseCase(attendanceRepository);

          return BlocProvider(
            create: (_) => AttendanceBloc(getTodaysAttendanceUseCase,
                getUserUseCase, getQuotaUseCase, updateWaktuKeluarUseCase),
            child: const HomePage(),
          );
        },
      ),

      // Presensi Route
      GoRoute(
        path: '/presensi',
        builder: (context, state) {
          final presensiApiDataSource = PresensiApiDataSource(dioClient);
          final presensiRepository =
              PresensiRepositoryImpl(presensiApiDataSource);
          final storePresensiUseCase = StorePresensiUseCase(presensiRepository);

          return BlocProvider(
            create: (_) => PresensiBloc(storePresensiUseCase),
            child: const PresensiPage(),
          );
        },
      ),

      // History Route
      GoRoute(
        path: '/history',
        builder: (context, state) {
          // Inisialisasi datasource, repository, dan use cases
          final historyApiDataSource = HistoryApiDataSource(dioClient);
          final historyRepository = HistoryRepositoryImpl(historyApiDataSource);
          final getHistoryUseCase = GetHistoryUseCase(historyRepository);
          // Inisialisasi Bloc dengan dua use cases
          return BlocProvider(
            create: (_) => HistoryBloc(
              getHistoryUseCase,
            ),
            child: const HistoryPage(),
          );
        },
      ),

      // Permit Route
      GoRoute(
        path: '/permit',
        builder: (context, state) => const PermitPage(),
      ),

      // Profile Route
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],

    // Error Handling
    errorBuilder: (context, state) {
      return const Scaffold(
        body: Center(
          child: Text('Route not found'),
        ),
      );
    },
  );
}
