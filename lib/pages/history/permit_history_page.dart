import 'package:flutter/material.dart';

void main() {
  runApp(PermitApp());
}

class PermitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PermitHistoryPage(),
    );
  }
}

class PermitHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Perizinan'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Add navigation back
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.04), // Adjust padding for mobile
        children: [
          PermitCard(
            name: 'Anomalia',
            date: '20-01-2024',
            permitType: 'Sakit',
            status: 'Diterima',
            statusColor: Colors.green,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenWidth * 0.04),
          PermitCard(
            name: 'Anomalia',
            date: '20-01-2024',
            permitType: 'Cuti',
            status: 'Ditolak',
            statusColor: Colors.red,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenWidth * 0.04),
          PermitCard(
            name: 'Anomalia',
            date: '20-01-2024',
            permitType: 'Cuti',
            status: 'Menunggu',
            statusColor: Colors.orange,
            screenWidth: screenWidth,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Current tab index (History tab selected)
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Permit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PermitCard extends StatelessWidget {
  final String name;
  final String date;
  final String permitType;
  final String status;
  final Color statusColor;
  final double screenWidth;

  const PermitCard({
    required this.name,
    required this.date,
    required this.permitType,
    required this.status,
    required this.statusColor,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.png'), // Placeholder avatar
            radius: screenWidth * 0.1, // Responsive radius for mobile
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text('Tanggal: $date', style: TextStyle(fontSize: screenWidth * 0.04)),
                Text('Jenis Izin: $permitType', style: TextStyle(fontSize: screenWidth * 0.04)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
