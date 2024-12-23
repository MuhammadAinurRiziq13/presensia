import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../splash_screen/splash_screen.dart';
import 'profile_detail_page.dart';
import 'help_page.dart';
import 'privacy_policy_page.dart';
import 'terms_and_conditions_page.dart';
import '../../../presentation/widgets/bottom_navigation.dart';
import 'package:presensia/presentation/blocs/profile/profile_bloc.dart';
import 'package:presensia/presentation/blocs/profile/profile_event.dart';
import 'package:presensia/presentation/blocs/profile/profile_state.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  void _fetchAllData() {
    context.read<ProfileBloc>().add(FetchAllDataEvent());
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
                context.read<ProfileBloc>().add(LogoutEvent());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileInitial) {
          // Navigasi ke halaman SplashScreen setelah logout
          context.go('/');
        } else if (state is ProfileFailure) {
          // Tampilkan error jika logout gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                              'https://i.pinimg.com/236x/f9/51/b3/f951b38701e4ce78644595c7a6022c27.jpg')
                          as ImageProvider,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileSuccess) {
                    return Column(
                      children: [
                        Text(
                          state.user.namaPegawai ?? '---',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          state.user.jabatan ?? '---',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  } else if (state is ProfileLoading) {
                    return Column(
                      children: [
                        Container(
                          height: 18,
                          width: 100,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 15,
                          width: 80,
                          color: Colors.grey[300],
                        ),
                      ],
                    );
                  } else if (state is ProfileFailure) {
                    return Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.person,
                      text: 'Profil Saya',
                      onTap: () {
                        context.go('/profile/detail');
                      },
                    ),
                    const Divider(),
                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline,
                      text: 'Bantuan',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpPage()),
                        );
                      },
                    ),
                    const Divider(),
                    _buildMenuItem(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      text: 'Kebijakan Privasi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyPage()),
                        );
                      },
                    ),
                    const Divider(),
                    _buildMenuItem(
                      context,
                      icon: Icons.description_outlined,
                      text: 'Syarat & Ketentuan',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionsPage()),
                        );
                      },
                    ),
                    const Divider(),
                    _buildLogoutMenuItem(
                      context,
                      icon: Icons.logout,
                      text: 'Keluar',
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
            // Membaca data id_absensi dari SharedPreferences dan mengonversi menjadi integer
            Future<int?> getIdAbsensi() async {
              final prefs = await SharedPreferences.getInstance();
              return prefs.getInt('id_absensi');
            }

            return FutureBuilder<int?>(
              future: getIdAbsensi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Menampilkan indikator loading ketika data sedang dimuat
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Menangani kesalahan jika ada error dalam mengambil data
                  return const Icon(Icons.error);
                } else {
                  int? idAbsensi = snapshot.data;

                  // Mengatur kondisi FAB berdasarkan id_absensi yang diambil
                  final isDisabled = idAbsensi != null;

                  return SizedBox(
                    width: 65.0,
                    height: 65.0,
                    child: FloatingActionButton(
                      onPressed: isDisabled
                          ? null
                          : () {
                              GoRouter.of(context).go('/presensi');
                            },
                      backgroundColor: isDisabled ? Colors.green : Colors.blue,
                      shape: const CircleBorder(),
                      child: Icon(
                        isDisabled ? Icons.check_circle : Icons.camera_alt,
                        size: 35.0,
                        color: Colors.white,
                      ),
                      heroTag: 'fab-home', // Tag unik untuk FAB di halaman ini
                    ),
                  );
                }
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const BottomNavigationWidget(
          currentIndex: 4, // Index tab aktif untuk halaman Home
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String text,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutMenuItem(BuildContext context,
      {required IconData icon,
      required String text,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        text,
        style: const TextStyle(color: Colors.red),
      ),
      onTap: onTap,
    );
  }
}
