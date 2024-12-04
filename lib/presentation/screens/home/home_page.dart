import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/flushbar_helper.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_state.dart';
import '../../blocs/home/home_event.dart';
import '../../../presentation/widgets/bottom_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSlideButton = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkPresentStatus();
    _fetchAllData();
  }

  void _fetchAllData() async {
    context.read<AttendanceBloc>().add(FetchAllDataEvent());
  }

  void _checkLoginStatus() async {
    // Memeriksa status login dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    bool? isLogined = prefs.getBool('isLogined') ?? false;

    if (isLogined) {
      showSuccessFlushbar(
          context, 'Login berhasil! Selamat datang di aplikasi!');
      prefs.setBool('isLogined', false);
    }
  }

  void _checkPresentStatus() async {
    // Memeriksa status login dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    bool? isPresent = prefs.getBool('isPresent') ?? false;

    if (isPresent) {
      showSuccessFlushbar(context, 'Presensi berhasil !!');
      prefs.setBool('isPresent', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _fetchAllData(); // Memanggil ulang data saat layar ditarik
          },
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Agar tetap bisa scroll meski datanya sedikit
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Profile Section
                Row(
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.user.jabatan ?? '---',
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ],
                            );
                          } else if (state is AttendanceLoading) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 18,
                                    width: 100,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 15,
                                    width: 80,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications,
                          color: Colors.blue, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Date and Location Section
                BlocBuilder<AttendanceBloc, AttendanceState>(
                  builder: (context, state) {
                    if (state is AttendanceAndUserSuccess) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.currentDate,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Lowokwaru, Malang',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 20),
                // Daily Presence Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Presensi hari ini',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<AttendanceBloc, AttendanceState>(
                      builder: (context, state) {
                        if (state is AttendanceLoading) {
                          // Show shimmer loading skeleton
                          return Column(
                            children: [
                              _buildSkeleton(),
                              const SizedBox(height: 20),
                              _buildSkeleton(),
                            ],
                          );
                        } else if (state is AttendanceAndUserSuccess) {
                          final attendance = state.attendance;

                          // Placeholder values for empty data
                          final masuk = attendance.isNotEmpty &&
                                  attendance[0].waktuMasuk != null
                              ? attendance[0]
                                  .formatDate(attendance[0].waktuMasuk)
                              : '---';
                          final keluar = attendance.isNotEmpty &&
                                  attendance[0].waktuKeluar != null
                              ? attendance[0]
                                  .formatDate(attendance[0].waktuKeluar)
                              : '---';
                          final totalJam = attendance.isNotEmpty &&
                                  attendance[0].totalJam != null
                              ? attendance[0].totalJam
                              : '---';
                          final statusAbsen = attendance.isNotEmpty &&
                                  attendance[0].statusAbsen.isNotEmpty
                              ? attendance[0].statusAbsen
                              : '---';

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPresenceCard(
                                        'Masuk', masuk, Icons.login),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildPresenceCard(
                                        'Keluar', keluar, Icons.logout),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPresenceCard(
                                        'Total Jam', totalJam, Icons.timer),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildPresenceCard(
                                        'Status Kehadiran',
                                        statusAbsen,
                                        Icons.check),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (state is AttendanceFailure) {
                          return Center(
                            child: Text(
                              state.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return Container(); // Return empty container if no state is loaded
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Daily Presence Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Presensi Tahun ini',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<AttendanceBloc, AttendanceState>(
                      builder: (context, state) {
                        if (state is AttendanceLoading) {
                          // Show shimmer loading skeleton
                          return Column(
                            children: [
                              _buildSkeleton(),
                            ],
                          );
                        } else if (state is AttendanceAndUserSuccess) {
                          final sisaWfa = state.sisaWfa.toString();
                          final sisaCuti = state.sisaCuti.toString();

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildPresenceCard(
                                      'Jatah WFA',
                                      '$sisaWfa Hari',
                                      Icons.home,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildPresenceCard(
                                      'Jatah Cuti',
                                      '$sisaCuti Hari',
                                      Icons.calendar_today,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else if (state is AttendanceFailure) {
                          return Center(
                            child: Text(
                              state.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return Container(); // Return empty container if no state is loaded
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                BlocBuilder<AttendanceBloc, AttendanceState>(
                  builder: (context, state) {
                    if (state is AttendanceAndUserSuccess &&
                        state.attendance.isNotEmpty &&
                        state.attendance[0].waktuKeluar == null) {
                      // Jika waktuKeluar masih null, tampilkan SliderButton
                      return _buildSliderButton();
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
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
        currentIndex: 0, // Index tab aktif untuk halaman Home
      ),
    );
  }

  Widget _buildPresenceCard(String title, String time, IconData icon) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 177, 216, 248),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(title)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              time, // This will display either time or "---"
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderButton() {
    return BlocConsumer<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceUpdateSuccess) {
          // Jika update berhasil, panggil FetchAllDataEvent
          _fetchAllData();

          // Tampilkan pesan sukses
          showSuccessFlushbar(context, 'Berhasil keluar !! Silahkan Istirahat');
        } else if (state is AttendanceFailure) {
          // Tampilkan pesan error jika gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return SlideAction(
          onSubmit: () {
            // Panggil event UpdateWaktuKeluarEvent
            context.read<AttendanceBloc>().add(UpdateWaktuKeluarEvent());
          },
          text: 'Geser untuk keluar',
          textStyle: const TextStyle(fontSize: 14, color: Colors.white),
          sliderButtonIcon:
              const Icon(Icons.arrow_forward, color: Colors.red, size: 20),
          innerColor: Colors.white,
          outerColor: Colors.red,
          height: 65,
          borderRadius: 10,
        );
      },
    );
  }
}
