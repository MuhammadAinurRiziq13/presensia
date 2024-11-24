import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../blocs/history/history_bloc.dart';
import '../../blocs/history/history_state.dart';
import '../../blocs/history/history_event.dart';
import '../../../presentation/widgets/bottom_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:presensia/domain/entities/absensi.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
  }

  void _fetchHistoryData() async {
    context.read<HistoryBloc>().add(GetHistoryButtonPressed(
        idPegawai: 1)); // Replace with actual ID if needed
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
            _fetchHistoryData(); // Fetch data again on pull to refresh
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      return _buildHistoryTable(state.history);
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
            // Format Tanggal
            String formattedDate = '';
            if (attendance.tanggal != null) {
              try {
                formattedDate =
                    DateFormat('dd MMM yyyy').format(attendance.tanggal!);
              } catch (e) {
                formattedDate = attendance.tanggal.toString();
              }
            }

            // Handle waktuMasuk and waktuKeluar (ensure they are String)
            String formattedMasuk = attendance.waktuMasuk?.toString() ?? '---';
            String formattedKeluar =
                attendance.waktuKeluar?.toString() ?? '---';

            // Handle statusAbsen
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

  // Skeleton for loading
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
