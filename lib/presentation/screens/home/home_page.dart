import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/blocs/home/home_bloc.dart';
import '../../../presentation/blocs/home/home_event.dart';
import '../../../presentation/blocs/home/home_state.dart';
import '../../widgets/bottom_navigation.dart';
import '../../../core/utils/flushbar_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchAllData();
  }

  void _fetchAllData() {
    context.read<AttendanceBloc>().add(FetchAllDataEvent());
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogined = prefs.getBool('isLogined') ?? false;

    if (isLogined) {
      showSuccessFlushbar(
          context, 'Login berhasil! Selamat datang di aplikasi!');
      prefs.setBool('isLogined', false); // Reset login status
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _fetchAllData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildProfileSection(),
                const SizedBox(height: 20),
                _buildDateAndLocationSection(),
                const SizedBox(height: 20),
                _buildDailyPresenceSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/presensi');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.camera_alt, size: 35, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavigationWidget(currentIndex: 0),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              'https://i.pinimg.com/236x/f9/51/b3/f951b38701e4ce78644595c7a6022c27.jpg'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: BlocBuilder<AttendanceBloc, AttendanceState>(
            builder: (context, state) {
              if (state is AttendanceAndUserSuccess) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user.namaPegawai ?? '---',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      state.user.jabatan ?? '---',
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                );
              } else if (state is AttendanceLoading) {
                return _buildShimmerProfile();
              }
              return const SizedBox();
            },
          ),
        ),
        const Icon(Icons.notifications, color: Colors.blue, size: 28),
      ],
    );
  }

  Widget _buildDateAndLocationSection() {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        if (state is AttendanceAndUserSuccess) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(state.currentDate,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Lowokwaru, Malang',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildDailyPresenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Presensi hari ini',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoading) {
              return _buildShimmerPresence();
            } else if (state is AttendanceAndUserSuccess) {
              final attendance = state.attendance;

              if (attendance == null || attendance.isEmpty) {
                return const Text('Belum ada data presensi.');
              }

              return Row(
                children: [
                  Expanded(
                    child: _buildPresenceCard(
                      'Masuk',
                      attendance[0]?.waktuMasuk ?? '---', // Pastikan index aman
                      Icons.login,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPresenceCard(
                      'Keluar',
                      attendance[0]?.waktuKeluar ??
                          '---', // Pastikan index aman
                      Icons.logout,
                    ),
                  ),
                ],
              );
            }
            return const Text('Belum ada data presensi.');
          },
        ),
      ],
    );
  }

  Widget _buildShimmerProfile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 18, width: 100, color: Colors.grey),
          const SizedBox(height: 8),
          Container(height: 15, width: 80, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildShimmerPresence() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          Expanded(child: Container(height: 120, color: Colors.grey)),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 120, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPresenceCard(String title, String time, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text('$title: $time'),
          ],
        ),
      ),
    );
  }
}
