import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/history/history_bloc.dart';
import '../../blocs/history/history_state.dart';
import '../../blocs/history/history_event.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../../presentation/widgets/bottom_navigation.dart';
import 'package:presensia/domain/entities/absensi.dart';
import 'package:table_calendar/table_calendar.dart';

extension DateExtensions on DateTime {
  bool isSameDate(DateTime? other) {
    if (other == null) return false;
    return year == other.year && month == other.month && day == other.day;
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime? _startDate;
  DateTime _focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _focusedDate = _startDate!;
    _fetchHistoryData();
  }

  void _fetchHistoryData() {
    context.read<HistoryBloc>().add(GetHistoryButtonPressed(idPegawai: 1));
  }

  List<AbsensiEntity> _filterHistoryBySelectedDate(
      List<AbsensiEntity> history, DateTime? selectedDate) {
    if (selectedDate == null) return [];
    return history
        .where((attendance) =>
            attendance.tanggal?.isSameDate(selectedDate) ?? false)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Presensi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchHistoryData,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _fetchHistoryData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildCalendarFilter(),
                const SizedBox(height: 20),
                const Text(
                  'Presensi hari ini',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Column(
                          children:
                              List.generate(5, (index) => _buildLoadingRow()),
                        ),
                      );
                    } else if (state is HistorySuccess) {
                      final filteredHistory = _filterHistoryBySelectedDate(
                          state.history, _startDate);
                      return filteredHistory.isNotEmpty
                          ? _buildHistoryTable(filteredHistory)
                          : Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: const Center(
                                child: Text(
                                  "Tidak ada Absensi untuk tanggal ini.",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                    } else if (state is HistoryFailure) {
                      return Center(
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigationWidget(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildCalendarFilter() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDate,
      selectedDayPredicate: (day) => _startDate?.isSameDate(day) ?? false,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDate = focusedDay;
          _startDate = selectedDay; // Simpan tanggal yang dipilih
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
        weekendTextStyle: TextStyle(color: Colors.red),
        outsideDaysVisible: false,
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
    );
  }

  Widget _buildDateSection(String date) {
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
            DateFormat('dd').format(DateFormat('dd MMM yyyy').parse(date)),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            DateFormat('EEE').format(DateFormat('dd MMM yyyy').parse(date)),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryExitTimes(String label, String time) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatus(String status) {
    return Text(
      status,
      style: TextStyle(
        color: status == "Hadir" ? Colors.green : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildHistoryTable(List<AbsensiEntity> history) {
    if (history.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Tidak ada kehadiran pada hari ini"),
        ),
      );
    }

    return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Prevent scrolling conflicts
      shrinkWrap: true, // Allow embedding in scrollable parent
      itemCount: history.length,
      itemBuilder: (context, index) {
        final attendance = history[index];

        String formattedDate = '';
        if (attendance.tanggal != null) {
          try {
            formattedDate =
                DateFormat('dd MMM yyyy').format(attendance.tanggal!);
          } catch (e) {
            formattedDate = attendance.tanggal.toString();
          }
        }

        // Format waktu masuk dan keluar menjadi HH:mm (24 jam)
        String formattedMasuk = attendance.waktuMasuk != null
            ? DateFormat('HH:mm').format(attendance.waktuMasuk!)
            : '---';
        String formattedKeluar = attendance.waktuKeluar != null
            ? DateFormat('HH:mm').format(attendance.waktuKeluar!)
            : '---';

        String statusAbsen = attendance.statusAbsen ?? '---';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildDateSection(formattedDate),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildEntryExitTimes('Masuk', formattedMasuk),
                          _buildEntryExitTimes('Keluar', formattedKeluar),
                          _buildStatus(statusAbsen),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.blue, size: 16),
                          SizedBox(width: 4.0),
                          Text(
                            "Lowokwaru, Malang, Jawa Timur", // Example static location
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 40,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
