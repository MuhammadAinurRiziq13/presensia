import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/history/history_bloc.dart';
import '../../blocs/history/history_state.dart';
import '../../blocs/history/history_event.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../../presentation/widgets/bottom_navigation.dart';
import 'package:go_router/go_router.dart';
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
  DateTime? _endDate;
  DateTime _focusedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
    _focusedDate = DateTime.now();
  }

  void _fetchHistoryData() {
    // ID pegawai sementara dibuat statis.
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
        title: const Text('History'),
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
                          : const Center(
                              child:
                                  Text("Tidak ada Absensi untuk tanggal ini."),
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

  Widget _buildHistoryTable(List<AbsensiEntity> history) {
    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Tanggal')),
            DataColumn(label: Text('Masuk')),
            DataColumn(label: Text('Keluar')),
            DataColumn(label: Text('Status')),
          ],
          rows: history.map((attendance) {
            String formattedDate = '';
            if (attendance.tanggal != null) {
              try {
                formattedDate =
                    DateFormat('dd MMM yyyy').format(attendance.tanggal!);
              } catch (e) {
                formattedDate = attendance.tanggal.toString();
              }
            }

            String formattedMasuk = attendance.waktuMasuk?.toString() ?? '---';
            String formattedKeluar =
                attendance.waktuKeluar?.toString() ?? '---';

            String statusAbsen = attendance.statusAbsen ?? '---';

            return DataRow(cells: [
              DataCell(Text(formattedDate)),
              DataCell(Text(formattedMasuk)),
              DataCell(Text(formattedKeluar)),
              DataCell(Text(statusAbsen)),
            ]);
          }).toList(),
        ),
      ],
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
