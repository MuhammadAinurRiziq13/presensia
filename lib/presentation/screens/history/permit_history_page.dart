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
                      children: List.generate(
                        6,
                        (index) => Column(
                          children: [
                            _buildLoadingRow(),
                            SizedBox(height: 13), // Jarak ke bawah
                          ],
                        ),
                      ),
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
        if (permit.statusIzin == 'Disetujui') {
          statusColor = Colors.green;
        } else if (permit.statusIzin == 'Ditolak') {
          statusColor = Colors.red;
        }

        return Column(
          children: [
            PermitCard(
              date: '$formattedStartDate - $formattedEndDate',
              permitType: permit.jenisIzin ?? '---',
              status: permit.statusIzin ?? '---',
              keterangan: permit.keterangan ?? '---',
              statusColor: statusColor,
              screenWidth: screenWidth,
            ),
            SizedBox(height: screenWidth * 0.01),
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
            height: 220,
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

class PermitCard extends StatelessWidget {
  final String date;
  final String permitType;
  final String status;
  final String keterangan;
  final Color statusColor;
  final double screenWidth;

  const PermitCard({
    super.key,
    required this.date,
    required this.permitType,
    required this.status,
    required this.keterangan,
    required this.statusColor,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withOpacity(0.1),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Date and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: statusColor,
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ],
              ),

              // Divider
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.03,
                ),
                child: Divider(
                  color: statusColor.withOpacity(0.3),
                  thickness: 1.5,
                ),
              ),

              // Permit Type
              Row(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    color: statusColor,
                    size: screenWidth * 0.05,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis Izin',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        permitType,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Vertical Spacing
              SizedBox(height: screenWidth * 0.03),

              // Description
              Row(
                children: [
                  Icon(
                    Icons.notes,
                    color: statusColor,
                    size: screenWidth * 0.05,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keterangan',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.01),
                      Text(
                        keterangan,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
