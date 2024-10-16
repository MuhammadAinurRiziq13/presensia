import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showSlideButton = true;

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
              _buildDateAndLocation(),
              const SizedBox(height: 20),
              _buildDailyPresenceSection(),
              const SizedBox(height: 20),
              _buildMonthlyPresenceSection(),
              const SizedBox(height: 20),
              if (_showSlideButton) _buildSliderButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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

  Widget _buildDateAndLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Minggu, 16 September 2024',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
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
            Expanded(
                child: _buildPresenceDayCard('Masuk', '08:30', Icons.login)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildPresenceDayCard('Keluar', '17:30', Icons.logout)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child:
                    _buildPresenceDayCard('Total Jam', '10:00', Icons.timer)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildPresenceDayCard(
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
                child: _buildPresenceMonthCard('Jatah WFA', '3', Icons.home)),
            const SizedBox(width: 16),
            Expanded(
                child: _buildPresenceMonthCard(
                    'Jatah Cuti', '4', Icons.calendar_today)),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SlideAction(
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
      ),
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

  Widget _buildPresenceDayCard(String title, String time, IconData icon) {
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

  Widget _buildPresenceMonthCard(String title, String time, IconData icon) {
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
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: time,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: " Hari",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
