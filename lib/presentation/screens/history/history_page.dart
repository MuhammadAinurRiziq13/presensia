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

  List<AbsensiEntity> _filterHistoryByDate(List<AbsensiEntity> history) {
    if (_startDate == null && _endDate == null) return history;

    return history.where((attendance) {
      if (attendance.tanggal == null) return false;

      final tanggal = attendance.tanggal!;
      if (_startDate != null && tanggal.isBefore(_startDate!)) return false;
      if (_endDate != null && tanggal.isAfter(_endDate!)) return false;

      return true;
    }).toList();
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
                      final filteredHistory =
                          _filterHistoryByDate(state.history);
                      return filteredHistory.isNotEmpty
                          ? _buildHistoryTable(filteredHistory)
                          : const Center(
                              child: Text("Tidak ada data ditemukan."));
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
      firstDay: DateTime(2000),
      lastDay: DateTime.now(),
      focusedDay:
          _focusedDate ?? DateTime.now(), // Fallback jika _focusedDate null
      selectedDayPredicate: (day) {
        if (_startDate == null && _endDate == null) return false;
        return (_startDate != null && day.isSameDate(_startDate)) ||
            (_endDate != null && day.isSameDate(_endDate));
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDate = focusedDay; // Pastikan tidak null
          if (_startDate == null || (_startDate != null && _endDate != null)) {
            _startDate = selectedDay;
            _endDate = null;
          } else {
            if (selectedDay.isBefore(_startDate!)) {
              _endDate = _startDate;
              _startDate = selectedDay;
            } else {
              _endDate = selectedDay;
            }
          }
        });
      },
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
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











// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:presensia/presentation/blocs/history/history_bloc.dart';
// import 'package:presensia/presentation/blocs/history/history_event.dart';
// import 'package:presensia/presentation/blocs/history/history_state.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../../../presentation/widgets/bottom_navigation.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   DateTime selectedDate = DateTime.now();
//   bool isLoadingIdPegawai = true; // Flag untuk loading ID Pegawai

//   @override
//   void initState() {
//     super.initState();
//     _loadIdPegawai(); // Memuat ID pegawai saat initState
//   }

//   Future<void> _loadIdPegawai() async {
//     final prefs = await SharedPreferences.getInstance();
//     final idPegawai = prefs.getInt('id_pegawai');

//     if (idPegawai != null) {
//       BlocProvider.of<HistoryBloc>(context)
//           .add(GetHistoryButtonPressed(idPegawai: idPegawai));
//     } else {
//       Future.delayed(Duration.zero, () {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('ID Pegawai tidak ditemukan')),
//           );
//         }
//       });
//     }

//     setState(() {
//       isLoadingIdPegawai = false; // Set loading ke false setelah pemrosesan
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Riwayat Presensi',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: isLoadingIdPegawai
//           ? const Center(child: CircularProgressIndicator())
//           : _buildHistoryContent(),
//       bottomNavigationBar: const BottomNavigationWidget(
//         currentIndex: 1,
//       ),
//     );
//   }

//   Widget _buildHistoryContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildCalendar(),
//         const SizedBox(height: 16.0),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             'Presensi Anda',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Expanded(child: _buildHistoryList()),
//       ],
//     );
//   }

//   Widget _buildCalendar() {
//     return TableCalendar(
//       firstDay: DateTime.utc(2020, 1, 1),
//       lastDay: DateTime.utc(2030, 12, 31),
//       focusedDay: selectedDate,
//       selectedDayPredicate: (day) => isSameDay(selectedDate, day),
//       onDaySelected: (selectedDay, focusedDay) {
//         setState(() {
//           selectedDate = selectedDay;
//         });
//       },
//       calendarStyle: const CalendarStyle(
//         todayDecoration: BoxDecoration(
//           color: Colors.blue,
//           shape: BoxShape.circle,
//         ),
//         selectedDecoration: BoxDecoration(
//           color: Colors.orange,
//           shape: BoxShape.circle,
//         ),
//       ),
//       headerStyle: const HeaderStyle(
//         formatButtonVisible: false,
//         titleCentered: true,
//         titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//       startingDayOfWeek: StartingDayOfWeek.monday,
//     );
//   }

//   Widget _buildAttendanceList() {
//     return BlocBuilder<HistoryBloc, HistoryState>(
//       builder: (context, state) {
//         if (state is HistoryLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is HistorySuccess) {
//           return _buildHistoryListView(state.history);
//         } else if (state is HistoryFailure) {
//           return Center(
//             child: Text(
//               'Error: ${state.errorMessage}',
//               style: const TextStyle(color: Colors.red),
//               textAlign: TextAlign.center,
//             ),
//           );
//         } else {
//           return const Center(
//             child: Text('Tidak ada data presensi.'),
//           );
//         }
//       },
//     );
//   }

//   Widget _buildHistoryListView(List<AbsensiEntity> history) {
//     final selectedDayData = history.where((item) {
//       return isSameDay(item.tanggal, selectedDate);
//     }).toList();

//     if (selectedDayData.isEmpty) {
//       return const Center(
//         child: Text("Tidak ada absensi untuk tanggal ini."),
//       );
//     }

//     return ListView.builder(
//       itemCount: selectedDayData.length,
//       itemBuilder: (context, index) {
//         final item = selectedDayData[index];
//         return ListTile(
//           title: Text('Status: ${item.statusAbsen}'),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Waktu Masuk: ${item.waktuMasuk?.hour ?? '--'}:${item.waktuMasuk?.minute ?? '--'}',
//               ),
//               Text(
//                 'Waktu Keluar: ${item.waktuKeluar?.hour ?? '--'}:${item.waktuKeluar?.minute ?? '--'}',
//               ),
//               Text('Lokasi: ${item.lokasiAbsen ?? "Tidak tersedia"}'),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
