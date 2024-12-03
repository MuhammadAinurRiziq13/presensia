import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/presentation/blocs/permit/permit_bloc.dart';
import 'package:presensia/presentation/blocs/permit/permit_event.dart';
import 'package:presensia/presentation/blocs/permit/permit_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:presensia/domain/entities/permit.dart'; // Ganti dengan entitas permit Anda

class HistoryPermitPage extends StatefulWidget {
  const HistoryPermitPage({super.key});

  @override
  _HistoryPermitPageState createState() => _HistoryPermitPageState();
}

class _HistoryPermitPageState extends State<HistoryPermitPage> {
  @override
  void initState() {
    super.initState();
    _fetchPermitHistoryData();
  }

  void _fetchPermitHistoryData() {
    context
        .read<PermitsBloc>()
        .add(GetPermitsEvent(idPegawai: 1)); // ID Pegawai masih statis
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Perizinan',
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
            _fetchPermitHistoryData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<PermitsBloc, PermitState>(
              builder: (context, state) {
                if (state is PermitLoadingState) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: List.generate(5, (index) => _buildLoadingRow()),
                    ),
                  );
                } else if (state is PermitSuccess) {
                  final permits = state.permits;
                  return _buildPermitCards(permits);
                } else if (state is PermitFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermitCards(List<PermitEntity> permits) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: permits.map((permit) {
        // Format Tanggal
        String formattedStartDate = '';
        String formattedEndDate = '';
        try {
          formattedStartDate =
              DateFormat('dd MMM yyyy').format(permit.tanggalMulai!);
          formattedEndDate =
              DateFormat('dd MMM yyyy').format(permit.tanggalAkhir!);
        } catch (e) {
          formattedStartDate = permit.tanggalMulai.toString();
          formattedEndDate = permit.tanggalAkhir.toString();
        }

        // Status Color
        Color statusColor = Colors.orange; // Default color
        if (permit.statusIzin == 'diacc') {
          statusColor = Colors.green;
        } else if (permit.statusIzin == 'ditolak') {
          statusColor = Colors.red;
        }

        return Column(
          children: [
            PermitCard(
              name:
                  'Anomalia', // Contoh nama pegawai, sesuaikan dengan data yang ada
              date: '$formattedStartDate - $formattedEndDate',
              permitType: permit.jenisIzin ?? '---',
              status: permit.statusIzin ?? '---',
              statusColor: statusColor,
              screenWidth: screenWidth,
            ),
            SizedBox(height: screenWidth * 0.04),
          ],
        );
      }).toList(),
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

class PermitCard extends StatelessWidget {
  final String name;
  final String date;
  final String permitType;
  final String status;
  final Color statusColor;
  final double screenWidth;

  const PermitCard({
    super.key,
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                const AssetImage('assets/avatar.png'), // Placeholder avatar
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
                Text('Tanggal: $date',
                    style: TextStyle(fontSize: screenWidth * 0.04)),
                Text('Jenis Izin: $permitType',
                    style: TextStyle(fontSize: screenWidth * 0.04)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
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
