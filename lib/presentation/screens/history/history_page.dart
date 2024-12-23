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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

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
        title: const Text(
          'Riwayat Presensi',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
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
                              List.generate(1, (index) => _buildLoadingRow()),
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
      floatingActionButton: Builder(
        builder: (context) {
          // Membaca data id_absensi dari SharedPreferences dan mengonversi menjadi integer
          Future<int?> getIdAbsensi() async {
            final prefs = await SharedPreferences.getInstance();
            return prefs.getInt('id_absensi');
          }

          return FutureBuilder<int?>(
            future: getIdAbsensi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Menampilkan indikator loading ketika data sedang dimuat
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Menangani kesalahan jika ada error dalam mengambil data
                return const Icon(Icons.error);
              } else {
                int? idAbsensi = snapshot.data;

                // Mengatur kondisi FAB berdasarkan id_absensi yang diambil
                final isDisabled = idAbsensi != null;

                return SizedBox(
                  width: 65.0,
                  height: 65.0,
                  child: FloatingActionButton(
                    onPressed: isDisabled
                        ? null
                        : () {
                            GoRouter.of(context).go('/presensi');
                          },
                    backgroundColor: isDisabled ? Colors.green : Colors.blue,
                    shape: const CircleBorder(),
                    child: Icon(
                      isDisabled ? Icons.check_circle : Icons.camera_alt,
                      size: 35.0,
                      color: Colors.white,
                    ),
                    heroTag: 'fab-home', // Tag unik untuk FAB di halaman ini
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavigationWidget(
        currentIndex: 1, // Index tab aktif untuk halaman Home
      ),
    );
  }

  Widget _buildCalendarFilter() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade500,
            Colors.blue.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Material(
          color: Colors.transparent,
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDate,
            selectedDayPredicate: (day) => _startDate?.isSameDate(day) ?? false,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDate = focusedDay;
                _startDate = selectedDay;
              });
            },
            calendarStyle: CalendarStyle(
              // Today styling with a glowing effect
              todayDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade900,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade700.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              todayTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              // Selected day with a vibrant highlight
              selectedDecoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.5),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              selectedTextStyle: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),

              // Default day styling
              defaultDecoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(
                color: Colors.white.withOpacity(0.9),
              ),

              // Weekend styling
              weekendTextStyle: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),

              // Outside days
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 1.2,
              ),
              leftChevronIcon: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
              ),
              rightChevronIcon: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,

            // Day name styling
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              weekendStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
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
        String lokasiAbsen = attendance.lokasiAbsen ?? '---';

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
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.blue, size: 16),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              lokasiAbsen ?? "Lokasi tidak tersedia",
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
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
            height: 110,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0), // Sudut membulat
            ),
          ),
        ),
      ],
    );
  }
}
