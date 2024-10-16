import 'dart:math'; // Add this for Random
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // For the calendar widget

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, String>> attendanceData = [];

  @override
  void initState() {
    super.initState();
    _generateAttendanceData(); // Generate attendance data for September until today
  }

  // Function to generate random attendance data
  void _generateAttendanceData() {
    List<String> days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    Random random = Random();

    // Start from 1 September
    DateTime startDate = DateTime(DateTime.now().year, 9, 1);
    // End at the current date (today)
    DateTime endDate = DateTime.now();

    // Generate data for each day from 1 September to today
    for (DateTime date = startDate;
        date.isBefore(endDate) ||
            date.isAtSameMomentAs(endDate); // Make sure to include the endDate
        date = date.add(const Duration(days: 1))) {
      String dayName = days[date.weekday % 7]; // Get day name (Min, Sen, etc.)
      bool isOnTime = random.nextBool(); // Random status for on-time or late

      attendanceData.add({
        "date": date.toIso8601String(), // Use ISO format for better accuracy
        "day": dayName, // Get the name of the day
        "entryTime": "08:30",
        "exitTime": "17:30",
        "status": isOnTime ? "OnTime" : "Late",
        "location": "Lowokwaru, Malang, Jawa Timur"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Presensi',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendar(),
            const SizedBox(height: 16.0),
            const Text(
              'Presensi Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(child: _buildAttendanceList()),
          ],
        ),
      ),
    );
  }

  // Widget to build the calendar at the top
  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: selectedDate,
      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          selectedDate = selectedDay; // Update the selected date
        });
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
    );
  }

  // Function to build the list of attendance data for the selected date
  Widget _buildAttendanceList() {
    // Filter data by selected date
    final selectedDayData = attendanceData.where((item) {
      DateTime itemDate = DateTime.parse(item['date']!);
      return isSameDay(itemDate, selectedDate);
    }).toList();

    if (selectedDayData.isEmpty) {
      return const Center(child: Text("Tidak ada kehadiran dalam hari ini"));
    }

    return ListView.builder(
      itemCount: selectedDayData.length,
      itemBuilder: (context, index) {
        final item = selectedDayData[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildDateSection(item['date']!, item['day']!),
                const SizedBox(width: 16.0),
                Expanded(child: _buildAttendanceDetails(item)),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget to build the left side date section
  Widget _buildDateSection(String date, String day) {
    DateTime parsedDate = DateTime.parse(date);
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            parsedDate.day.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            day,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Widget to build the details of each attendance record
  Widget _buildAttendanceDetails(Map<String, String> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildEntryExitTimes('Masuk', item['entryTime']!),
            _buildEntryExitTimes('Keluar', item['exitTime']!),
            _buildStatus(item['status']!),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue, size: 16),
            const SizedBox(width: 4.0),
            Text(item['location']!, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  // Widget to display entry and exit times
  Widget _buildEntryExitTimes(String label, String time) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Widget to display status
  Widget _buildStatus(String status) {
    return Text(
      status,
      style: TextStyle(
        color: status == "OnTime" ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
