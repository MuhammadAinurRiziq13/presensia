import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/permit/permit_bloc.dart';
import '../../blocs/permit/permit_event.dart';
import '../../blocs/permit/permit_state.dart';

class PermitRequestPage extends StatefulWidget {
  const PermitRequestPage({super.key});

  @override
  _PermitRequestPageState createState() => _PermitRequestPageState();
}

class _PermitRequestPageState extends State<PermitRequestPage> {
  final TextEditingController _jenisIzinController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  DateTime? _tanggalMulai;
  DateTime? _tanggalAkhir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Perizinan'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _jenisIzinController,
              decoration: const InputDecoration(labelText: 'Jenis Izin'),
            ),
            TextField(
              controller: _keteranganController,
              decoration: const InputDecoration(labelText: 'Keterangan'),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                setState(() {
                  _tanggalMulai = date;
                });
              },
              child: Text(_tanggalMulai == null
                  ? 'Pilih Tanggal Mulai'
                  : _tanggalMulai!.toLocal().toString()),
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                setState(() {
                  _tanggalAkhir = date;
                });
              },
              child: Text(_tanggalAkhir == null
                  ? 'Pilih Tanggal Akhir'
                  : _tanggalAkhir!.toLocal().toString()),
            ),
            ElevatedButton(
              onPressed: () {
                // Trigger Submit Event (Mengirim perizinan)
                context.read<PermitsBloc>().add(SubmitPermitEvent(
                      idPegawai: 1, // Ganti dengan ID Pegawai yang sesuai
                      jenisIzin: _jenisIzinController.text,
                      keterangan: _keteranganController.text,
                      tanggalMulai: _tanggalMulai!,
                      tanggalAkhir: _tanggalAkhir!,
                    ));
              },
              child: const Text('Ajukan Perizinan'),
            ),
          ],
        ),
      ),
    );
  }
}
// TEMPLATE UI JANGAN SAMPAI TERHAPUS
// import 'package:flutter/material.dart';

// class PermitReqPage extends StatefulWidget {
//   @override
//   _PermitReqPageState createState() => _PermitReqPageState();
// }

// class _PermitReqPageState extends State<PermitReqPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _jenisIzin = '';
//   String _keterangan = '';
//   DateTime _tanggalMulai = DateTime.now();
//   DateTime _tanggalAkhir = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Permintaan Perizinan'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Jenis Izin'),
//                 onSaved: (value) {
//                   _jenisIzin = value!;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Keterangan'),
//                 onSaved: (value) {
//                   _keterangan = value!;
//                 },
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: _tanggalMulai,
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   if (pickedDate != null && pickedDate != _tanggalMulai) {
//                     setState(() {
//                       _tanggalMulai = pickedDate;
//                     });
//                   }
//                 },
//                 child: Text('Pilih Tanggal Mulai'),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: _tanggalAkhir,
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   if (pickedDate != null && pickedDate != _tanggalAkhir) {
//                     setState(() {
//                       _tanggalAkhir = pickedDate;
//                     });
//                   }
//                 },
//                 child: Text('Pilih Tanggal Akhir'),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     print('Jenis Izin: $_jenisIzin');
//                     print('Keterangan: $_keterangan');
//                     print('Tanggal Mulai: $_tanggalMulai');
//                     print('Tanggal Akhir: $_tanggalAkhir');
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text('Ajukan Izin'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart'; // Untuk format tanggal

// // class PermitRequestPage extends StatefulWidget {
// //   const PermitRequestPage({super.key});

// //   @override
// //   _PermitRequestPageState createState() => _PermitRequestPageState();
// // }

// // class _PermitRequestPageState extends State<PermitRequestPage> {
// //   String _selectedPermitType = 'Cuti'; // Default tipe izin
// //   DateTimeRange? _dateRange; // Menyimpan range tanggal
// //   final TextEditingController _remarksController = TextEditingController();

// //   Future<void> _selectDateRange(BuildContext context) async {
// //     final DateTimeRange? pickedDateRange = await showDateRangePicker(
// //       context: context,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2025),
// //     );
// //     if (pickedDateRange != null && pickedDateRange != _dateRange) {
// //       setState(() {
// //         _dateRange = pickedDateRange;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Ajukan Perizinan',
// //           style: TextStyle(color: Colors.black),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         centerTitle: true,
// //         iconTheme: const IconThemeData(color: Colors.black),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Container(
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12.0),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.1),
// //                   blurRadius: 10,
// //                   offset: const Offset(0, 5),
// //                 ),
// //               ],
// //             ),
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: Colors.grey),
// //                     borderRadius: BorderRadius.circular(10.0),
// //                   ),
// //                   padding: const EdgeInsets.symmetric(
// //                       horizontal: 16.0, vertical: 8.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         "Jenis Perizinan:",
// //                         style: TextStyle(
// //                             fontSize: 16, fontWeight: FontWeight.bold),
// //                       ),
// //                       RadioListTile<String>(
// //                         title: const Text('Sakit'),
// //                         value: 'Sakit',
// //                         groupValue: _selectedPermitType,
// //                         onChanged: (String? value) {
// //                           setState(() {
// //                             _selectedPermitType = value!;
// //                           });
// //                         },
// //                       ),
// //                       RadioListTile<String>(
// //                         title: const Text('Cuti'),
// //                         value: 'Cuti',
// //                         groupValue: _selectedPermitType,
// //                         onChanged: (String? value) {
// //                           setState(() {
// //                             _selectedPermitType = value!;
// //                           });
// //                         },
// //                       ),
// //                       RadioListTile<String>(
// //                         title: const Text('WFA (Work From Anywhere)'),
// //                         value: 'WFA',
// //                         groupValue: _selectedPermitType,
// //                         onChanged: (String? value) {
// //                           setState(() {
// //                             _selectedPermitType = value!;
// //                           });
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 if (_selectedPermitType != 'Sakit')
// //                   GestureDetector(
// //                     onTap: () => _selectDateRange(context),
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         border: Border.all(color: Colors.grey),
// //                         borderRadius: BorderRadius.circular(10.0),
// //                       ),
// //                       padding: const EdgeInsets.all(16),
// //                       child: Text(
// //                         _dateRange == null
// //                             ? 'Pilih Tanggal'
// //                             : '${DateFormat('dd MMM yyyy').format(_dateRange!.start)} - ${DateFormat('dd MMM yyyy').format(_dateRange!.end)}',
// //                         style: const TextStyle(
// //                             fontSize: 16, fontWeight: FontWeight.bold),
// //                       ),
// //                     ),
// //                   ),
// //                 const SizedBox(height: 16),
// //                 TextField(
// //                   controller: _remarksController,
// //                   decoration: InputDecoration(
// //                     labelText: 'Keterangan',
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10.0),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     // Aksi ketika tombol kirim ditekan
// //                   },
// //                   child: const Text('Kirim'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Widget untuk menampilkan range tanggal pada kalender
// // class CalendarDateRangeWidget extends StatelessWidget {
// //   final DateTimeRange dateRange;

// //   const CalendarDateRangeWidget({super.key, required this.dateRange});

// //   @override
// //   Widget build(BuildContext context) {
// //     // Extracting the start and end date
// //     DateTime startDate = dateRange.start;
// //     DateTime endDate = dateRange.end;

// //     // Formatting months
// //     String startMonth = DateFormat('MMMM').format(startDate); // e.g. "January"
// //     String endMonth = DateFormat('MMMM').format(endDate); // e.g. "February"

// //     // Calculate total number of days in the range
// //     int daysCount =
// //         endDate.difference(startDate).inDays + 1; // Include the start day

// //     // Prepare the display text
// //     String displayText;
// //     if (startMonth == endMonth) {
// //       displayText = '$startMonth ($daysCount hari)'; // Same month
// //     } else {
// //       displayText =
// //           '$startMonth - $endMonth ($daysCount hari)'; // Different months
// //     }

// //     return Text(
// //       displayText,
// //       style: const TextStyle(
// //           fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
// //     );
// //   }
// // }
