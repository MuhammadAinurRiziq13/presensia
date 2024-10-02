import 'package:flutter/material.dart';
import '../../widgets/slide_unlock_button.dart';

class HomePage extends StatefulWidget {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                buildProfileSection(),
                SizedBox(height: 8),
                buildDateAndLocation(),
                SizedBox(height: 16),
                buildDailyPresenceSection(),
                SizedBox(height: 16),
                buildMonthlyPresenceSection(),
                SizedBox(height: 16),
                if (_showSlideButton) buildSliderButton(context),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nomor Pegawai',
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anomalia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Mobile Developer',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.blue),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildDateAndLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Minggu, 16 September 2024',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue, size: 16),
            SizedBox(width: 4),
            Text(
              'Lowokwaru, Malang',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDailyPresenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Presensi hari ini',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: buildPresenceCard('Masuk', '08:30', Icons.login)),
            SizedBox(width: 16),
            Expanded(child: buildPresenceCard('Keluar', '17:30', Icons.logout)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: buildPresenceCard('Total Jam', '10:00', Icons.timer)),
            SizedBox(width: 16),
            Expanded(
                child: buildPresenceCard(
                    'Status Kehadiran', 'On Time', Icons.check)),
          ],
        ),
      ],
    );
  }

  Widget buildMonthlyPresenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Presensi Bulan Ini',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: buildPresenceCard('Jatah WFH', '3 Day', Icons.home)),
            SizedBox(width: 16),
            Expanded(
                child: buildPresenceCard(
                    'Jatah Cuti', '4 Day', Icons.calendar_today)),
          ],
        ),
      ],
    );
  }

  Widget buildSliderButton(BuildContext context) {
    return SlideToUnlockButton(
      onSlideComplete: () {
        setState(() {
          _showSlideButton = false;
        });
        // Handle the slide completion, e.g., log out the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged out successfully!')),
        );
      },
    );
  }

  Widget buildPresenceCard(String title, String time, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
