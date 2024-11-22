import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensia/presentation/blocs/history/history_bloc.dart';
import 'package:presensia/presentation/blocs/history/history_event.dart';
import 'package:presensia/presentation/blocs/history/history_state.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();
  bool isLoadingIdPegawai = true; // Flag untuk loading ID Pegawai

  @override
  void initState() {
    super.initState();
    _loadIdPegawai(); // Memuat ID pegawai saat initState
  }

  Future<void> _loadIdPegawai() async {
    final prefs = await SharedPreferences.getInstance();
    final idPegawai = prefs.getInt('id_pegawai');

    // Tambahkan log debugging untuk melihat apakah ID Pegawai berhasil diambil
    print('ID Pegawai dari SharedPreferences: $idPegawai');

    if (idPegawai != null) {
      // Setelah ID berhasil diambil, kirim event ke bloc dan set loading menjadi false
      BlocProvider.of<HistoryBloc>(context)
          .add(GetHistoryButtonPressed(idPegawai: idPegawai));
      setState(() {
        isLoadingIdPegawai = false; // Set loading ke false
      });
    } else {
      // Jika ID tidak ditemukan, tampilkan SnackBar dan set loading ke false
      Future.delayed(Duration.zero, () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ID Pegawai tidak ditemukan')),
          );
        }
      });
      setState(() {
        isLoadingIdPegawai =
            false; // Set loading ke false meskipun ID tidak ada
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
      body: isLoadingIdPegawai
          ? const Center(
              child: CircularProgressIndicator()) // Loading ID Pegawai
          : _buildHistoryContent(),
    );
  }

  Widget _buildHistoryContent() {
    return Column(
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
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: selectedDate,
      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          selectedDate = selectedDay;
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

  Widget _buildAttendanceList() {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HistoryLoaded) {
          final selectedDayData = state.absensiList.where((item) {
            return isSameDay(item.tanggal, selectedDate);
          }).toList();

          if (selectedDayData.isEmpty) {
            return const Center(
                child: Text("Tidak ada absensi untuk tanggal ini."));
          }

          return ListView.builder(
            itemCount: selectedDayData.length,
            itemBuilder: (context, index) {
              final item = selectedDayData[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        item.statusAbsen == 'Hadir' ? Colors.green : Colors.red,
                    child: Text(item.tanggal.day.toString()),
                  ),
                  title: Text('Status: ${item.statusAbsen}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Waktu Masuk: ${item.waktuMasuk?.hour ?? '--'}:${item.waktuMasuk?.minute ?? '--'}'),
                      Text(
                          'Waktu Keluar: ${item.waktuKeluar?.hour ?? '--'}:${item.waktuKeluar?.minute ?? '--'}'),
                      Text('Lokasi: ${item.lokasiAbsen ?? "Tidak tersedia"}'),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is HistoryFailure) {
          return Center(
            child: Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return const Center(child: Text('Tekan tombol untuk memuat data.'));
        }
      },
    );
  }
}
