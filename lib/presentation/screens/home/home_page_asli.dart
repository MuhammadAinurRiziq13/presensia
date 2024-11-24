import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/flushbar_helper.dart';
import '../../../presentation/widgets/bottom_navigation.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSlideButton = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildProfileSection(),
              const SizedBox(height: 20),
              _buildDailyPresenceSection(),
              const SizedBox(height: 20),
              _buildMonthlyPresenceSection(),
              const SizedBox(height: 20),
              if (_showSlideButton) _buildSliderButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65.0,
        height: 65.0,
        child: FloatingActionButton(
          onPressed: () {
            // Navigasi ke halaman presensi
            GoRouter.of(context).go('/presensi');
          },
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.camera_alt,
            size: 35.0, // Ukuran ikon lebih besar
            color: Colors.white,
          ),
          heroTag: 'fab-home', // Tag unik untuk FAB di halaman ini
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavigationWidget(
        currentIndex: 0, // Index tab aktif untuk halaman Home
      ),
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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anomalia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Mobile Developer',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications, color: Colors.blue, size: 28),
        ),
      ],
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
        Row(
          children: [
            Expanded(child: _buildPresenceCard('Masuk', '08:30', Icons.login)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildPresenceCard('Keluar', '17:30', Icons.logout)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildPresenceCard('Total Jam', '10:00', Icons.timer)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildPresenceCard(
                    'Status Kehadiran', 'On Time', Icons.check)),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthlyPresenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Presensi Bulan Ini',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildPresenceCard('Jatah WFA', '3 Hari', Icons.home)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildPresenceCard(
                    'Jatah Cuti', '4 Hari', Icons.calendar_today)),
          ],
        ),
      ],
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
              time,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderButton() {
    return SlideAction(
      onSubmit: () {
        setState(() => _showSlideButton = false);
        _showSuccessDialog(context);
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
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Anda berhasil keluar'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
