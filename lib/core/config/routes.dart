import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/core/utils/dio_client/dio_client.dart';
import 'package:presensia/core/utils/constants.dart';
import 'package:presensia/data/repositories/history_repository_impl.dart';
import 'package:presensia/data/repositories/auth_repository_impl.dart';
import 'package:presensia/data/repositories/home_repository_impl.dart';
import 'package:presensia/data/repositories/presensi_repository_impl.dart';
import 'package:presensia/data/repositories/profile_repository_impl.dart';
import 'package:presensia/data/repositories/permit_repository_impl.dart';
import 'package:presensia/data/datasources/history_api_datasource.dart';
import 'package:presensia/data/datasources/auth_api_datasource.dart';
import 'package:presensia/data/datasources/home_api_datasource.dart';
import 'package:presensia/data/datasources/permit_api_datasource.dart';
import 'package:presensia/data/datasources/presensi_api_datasource.dart';
import 'package:presensia/data/datasources/profile_api_datasource.dart';
import 'package:presensia/presentation/screens/home/home_page.dart';
import 'package:presensia/presentation/screens/login/login.dart';
import 'package:presensia/presentation/screens/register/register.dart';
import 'package:presensia/presentation/screens/register/register_image.dart';
import 'package:presensia/presentation/screens/splash_screen/splash_screen.dart';
import 'package:presensia/presentation/screens/profile/profile_page.dart';
import 'package:presensia/presentation/screens/profile/profile_detail_page.dart';
import 'package:presensia/presentation/screens/permit/permit_page.dart';
import 'package:presensia/presentation/screens/permit/permit_request_page.dart';
import 'package:presensia/presentation/screens/history/history_page.dart';
import 'package:presensia/presentation/screens/history/permit_history_page.dart';
import 'package:presensia/presentation/screens/presensi/presensi_page.dart';
import 'package:presensia/presentation/blocs/register/register_bloc.dart';
import 'package:presensia/presentation/blocs/login/login_bloc.dart';
import 'package:presensia/presentation/blocs/history/history_bloc.dart';
import 'package:presensia/presentation/blocs/home/home_bloc.dart';
import 'package:presensia/presentation/blocs/permit/permit_bloc.dart';
import 'package:presensia/presentation/blocs/presensi/presensi_bloc.dart';
import 'package:presensia/presentation/blocs/profile/profile_bloc.dart';
import 'package:presensia/presentation/blocs/profile/profile_detail_bloc.dart';
import 'package:presensia/domain/usecases/update_waktu_keluar_usecase.dart';
import 'package:presensia/domain/usecases/history_usecase.dart';
import 'package:presensia/domain/usecases/permit_usecase.dart';
import 'package:presensia/domain/usecases/register_usecase.dart';
import 'package:presensia/domain/usecases/register_image_usecase.dart';
import 'package:presensia/domain/usecases/login_usecase.dart';
import 'package:presensia/domain/usecases/get_today_attendance_usecase.dart';
import 'package:presensia/domain/usecases/get_user_usecase.dart';
import 'package:presensia/domain/usecases/get_quota_usecase.dart';
import 'package:presensia/domain/usecases/store_presensi_usecase.dart';
import 'package:presensia/domain/usecases/logout_usecase.dart';
import 'package:presensia/domain/usecases/change_password_usecase.dart';

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

          return BlocProvider(
            create: (_) => LoginBloc(loginUseCase),
            child: const LoginPage(),
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
          final registerImageUseCase = RegisterImageUseCase(authRepositoryImpl);

          return BlocProvider(
            create: (_) => RegisterBloc(registerUseCase, registerImageUseCase),
            child: const RegisterPage(),
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

      GoRoute(
        path: '/permit',
        builder: (context, state) {
          // Inisialisasi datasource, repository, dan use cases
          final permitApiDataSource = PermitApiDataSource(dioClient);
          final permitRepository = PermitRepositoryImpl(permitApiDataSource);
          final permitUseCase = PermitUseCase(permitRepository);

          return BlocProvider(
            create: (_) => PermitsBloc(permitUseCase),
            child: const PermitPage(),
          );
        },
      ),

      GoRoute(
        path: '/permit/history',
        builder: (context, state) {
          final permitApiDataSource = PermitApiDataSource(AppRoutes.dioClient);
          final permitRepository = PermitRepositoryImpl(permitApiDataSource);
          final permitUseCase = PermitUseCase(permitRepository);

          return BlocProvider(
            create: (_) => PermitsBloc(permitUseCase),
            child: const HistoryPermitPage(),
          );
        },
      ),

      GoRoute(
        path: '/permit/store',
        builder: (context, state) {
          final permitApiDataSource = PermitApiDataSource(AppRoutes.dioClient);
          final permitRepository = PermitRepositoryImpl(permitApiDataSource);
          final permitUseCase = PermitUseCase(permitRepository);

          return BlocProvider(
            create: (_) => PermitsBloc(permitUseCase),
            child: PermitRequestPage(),
          );
        },
      ),

      // Profile Route
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          final profileApiDataSource = AttendanceApiDataSource(dioClient);
          final profileRepository =
              AttendanceRepositoryImpl(profileApiDataSource);
          final authApiDataSource = AuthApiDataSource(dioClient);
          final authRepositoryImpl = AuthRepositoryImpl(authApiDataSource);
          final getUserUseCase = GetUserUseCase(profileRepository);
          final logoutUseCase = LogoutUseCase(authRepositoryImpl);

          return BlocProvider(
            create: (_) => ProfileBloc(getUserUseCase, logoutUseCase),
            child: const ProfilePage(),
          );
        },
      ),

      GoRoute(
        path: '/profile/detail',
        builder: (context, state) {
          final profileApiDataSource = AttendanceApiDataSource(dioClient);

          final profileRepository =
              AttendanceRepositoryImpl(profileApiDataSource);
          final getUserUseCase = GetUserUseCase(profileRepository);

          final profileDetailDataSource = ProfileApiDataSource(dioClient);
          final profileDetailRepository =
              ProfileRepositoryImpl(profileDetailDataSource);
          final changePasswordUseCase =
              ChangePasswordUseCase(profileDetailRepository);

          return BlocProvider(
            create: (_) =>
                ProfileDetailBloc(getUserUseCase, changePasswordUseCase),
            child: const ProfileDetailPage(),
          );
        },
      ),

      GoRoute(
        path: '/register/image',
        builder: (context, state) {
          final authApiDataSource = AuthApiDataSource(dioClient);
          final authRepositoryImpl = AuthRepositoryImpl(authApiDataSource);
          final registerUseCase = RegisterUseCase(authRepositoryImpl);
          final registerImageUseCase = RegisterImageUseCase(authRepositoryImpl);

          return BlocProvider(
            create: (_) => RegisterBloc(registerUseCase, registerImageUseCase),
            child: const RegisterImage(),
          );
        },
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
