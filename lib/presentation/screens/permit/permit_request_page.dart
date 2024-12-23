import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:presensia/presentation/blocs/permit/permit_bloc.dart';
import 'package:presensia/presentation/blocs/permit/permit_event.dart';
import 'package:presensia/presentation/blocs/permit/permit_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/flushbar_helper.dart';

class PermitRequestPage extends StatefulWidget {
  const PermitRequestPage({super.key});

  @override
  _PermitRequestPageState createState() => _PermitRequestPageState();
}

class _PermitRequestPageState extends State<PermitRequestPage> {
  String _selectedPermitType = 'Cuti'; // Default tipe izin
  DateTimeRange? _dateRange; // Menyimpan range tanggal
  final TextEditingController _remarksController = TextEditingController();
  File? _selectedDocument;
  bool _isSubmitting = false; // Untuk menampilkan indikator loading

  Future<int> _getIdPegawai() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id_pegawai') ?? 0;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Warna utama kalender
              onPrimary: Colors.white, // Warna teks di atas warna utama
              onSurface: Colors.blue, // Warna teks di atas permukaan
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Warna tombol teks
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDateRange != null && pickedDateRange != _dateRange) {
      setState(() {
        _dateRange = pickedDateRange;
      });
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedDocument = File(result.files.single.path!);
      });
    }
  }

  // Fungsi untuk menghapus dokumen
  void _removeDocument() {
    setState(() {
      _selectedDocument = null;
    });
  }

  // Fungsi untuk mereset semua input
  void _resetInputs() {
    setState(() {
      _selectedPermitType = 'Cuti';
      _dateRange = null;
      _remarksController.clear();
      _selectedDocument = null;
    });
  }

  void _submitPermit() async {
    final idPegawai = await _getIdPegawai();

    if (idPegawai == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID Pegawai tidak ditemukan')),
      );
      return;
    }

    if (_selectedPermitType == 'Sakit' && _selectedDocument == null) {
      showErrorFlushbar(context, 'Dokumen wajib diunggah untuk izin Sakit');
      return;
    }

    if (_dateRange == null) {
      showErrorFlushbar(context, 'Tanggal izin harus dipilih');
      return;
    }

    final jenisIzin = _selectedPermitType;
    final keterangan = _remarksController.text;
    final tanggalMulai = _dateRange!.start;
    final tanggalAkhir = _dateRange!.end;

    // Pastikan keterangan tidak kosong
    if (keterangan.isEmpty) {
      showErrorFlushbar(context, 'Keterangan wajib diisi');
      return;
    }

    // Pastikan tanggalMulai dan tanggalAkhir bukan null sebelum diproses
    if (tanggalMulai == null || tanggalAkhir == null) {
      showErrorFlushbar(context, 'Tanggal mulai dan akhir tidak valid');
      return;
    }
    print('Tanggal Mulai: $tanggalMulai');

    // Format tanggal agar sesuai dengan yang diharapkan oleh server
    final formattedTanggalMulai = DateFormat('yyyy-MM-dd').format(tanggalMulai);
    final formattedTanggalAkhir = DateFormat('yyyy-MM-dd').format(tanggalAkhir);

    // Log the data for debugging
    print('ID Pegawai: $idPegawai');
    print('Jenis Izin: $jenisIzin');
    print('Keterangan: $keterangan');
    print('Tanggal Mulai: $formattedTanggalMulai');
    print('Tanggal Akhir: $formattedTanggalAkhir');
    print('Dokumen: ${_selectedDocument?.path}');

    setState(() {
      _isSubmitting = true;
    });

    // Kirim event submit permit
    BlocProvider.of<PermitsBloc>(context).add(
      SubmitPermitEvent(
        jenisIzin: jenisIzin,
        keterangan: keterangan,
        tanggalMulai: tanggalMulai, // Kirim tanggal dalam format string
        tanggalAkhir: tanggalAkhir, // Kirim tanggal dalam format string
        dokumen: _selectedPermitType == 'Sakit'
            ? _selectedDocument
            : null, // Hanya kirim dokumen jika izin Sakit
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Ajukan Perizinan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: BlocListener<PermitsBloc, PermitState>(
        listener: (context, state) {
          if (state is PermitSubmittedState) {
            showSuccessFlushbar(context, 'Pengajuan berhasil !!');
            setState(() {
              _isSubmitting = false;
            });
            _resetInputs();
          } else if (state is PermitFailure) {
            showErrorFlushbar(context, state.message);
            setState(() {
              _isSubmitting = false;
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[50]!,
                    Colors.blue[100]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Permit Type Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jenis Perizinan:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        _buildRadioTile('Sakit', 'Sakit'),
                        _buildRadioTile('Cuti', 'Cuti'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Document Upload for Sick Leave
                  if (_selectedPermitType == 'Sakit')
                    Column(
                      children: [
                        _buildDocumentUploadButton(),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Date Range Picker
                  _buildDateRangePicker(),

                  const SizedBox(height: 16),

                  // Remarks TextField
                  TextField(
                    controller: _remarksController,
                    decoration: InputDecoration(
                      labelText: 'Keterangan',
                      labelStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.blue!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.blue!, width: 2),
                      ),
                    ),
                    cursorColor: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : _submitPermit, // Disable button while submitting
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSubmitting
                          ? Colors.white
                          : Colors.blue, // Change color when loading
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width:
                                24, // Set a fixed size for the progress indicator
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth:
                                  3, // Adjust stroke width for visibility
                            ),
                          )
                        : const Text(
                            'Ajukan Permohonan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for radio tiles
  Widget _buildRadioTile(String value, String title) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: Colors.blue,
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.blue!;
            }
            return Colors.blue!.withOpacity(0.5);
          }),
        ),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: TextStyle(color: Colors.blue),
        ),
        value: value,
        groupValue: _selectedPermitType,
        onChanged: (String? newValue) {
          setState(() {
            _selectedPermitType = newValue!;
            if (value != 'Sakit') {
              _selectedDocument = null;
            }
          });
        },
      ),
    );
  }

  // Helper method for document upload
  Widget _buildDocumentUploadButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickDocument,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: Text(
            _selectedDocument != null
                ? 'Dokumen: ${_selectedDocument!.path.split('/').last}'
                : 'Unggah Dokumen',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_selectedDocument != null)
          TextButton(
            onPressed: _removeDocument,
            child: Text(
              'Hapus Dokumen',
              style: TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }

  // Helper method for date range picker
  Widget _buildDateRangePicker() {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.blue),
            const SizedBox(width: 10),
            Text(
              _dateRange == null
                  ? 'Pilih Tanggal'
                  : '${DateFormat('dd MMM yyyy').format(_dateRange!.start)} - ${DateFormat('dd MMM yyyy').format(_dateRange!.end)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:presensia/presentation/blocs/permit/permit_bloc.dart';
// import 'package:presensia/presentation/blocs/permit/permit_event.dart';
// import 'package:presensia/presentation/blocs/permit/permit_state.dart';

// class PermitRequestPage extends StatefulWidget {
//   const PermitRequestPage({super.key});

//   @override
//   _PermitRequestPageState createState() => _PermitRequestPageState();
// }

// class _PermitRequestPageState extends State<PermitRequestPage> {
//   String _selectedPermitType = 'Cuti'; // Default tipe izin
//   DateTimeRange? _dateRange; // Menyimpan range tanggal
//   final TextEditingController _remarksController = TextEditingController();

//   Future<void> _selectDateRange(BuildContext context) async {
//     final DateTimeRange? pickedDateRange = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2025),
//     );
//     if (pickedDateRange != null && pickedDateRange != _dateRange) {
//       setState(() {
//         _dateRange = pickedDateRange;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Ajukan Perizinan',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Jenis Perizinan:",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Sakit'),
//                         value: 'Sakit',
//                         groupValue: _selectedPermitType,
//                         onChanged: (String? value) {
//                           setState(() {
//                             _selectedPermitType = value!;
//                           });
//                         },
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('Cuti'),
//                         value: 'Cuti',
//                         groupValue: _selectedPermitType,
//                         onChanged: (String? value) {
//                           setState(() {
//                             _selectedPermitType = value!;
//                           });
//                         },
//                       ),
//                       RadioListTile<String>(
//                         title: const Text('WFA (Work From Anywhere)'),
//                         value: 'WFA',
//                         groupValue: _selectedPermitType,
//                         onChanged: (String? value) {
//                           setState(() {
//                             _selectedPermitType = value!;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 if (_selectedPermitType != 'Sakit')
//                   GestureDetector(
//                     onTap: () => _selectDateRange(context),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: Text(
//                         _dateRange == null
//                             ? 'Pilih Tanggal'
//                             : '${DateFormat('dd MMM yyyy').format(_dateRange!.start)} - ${DateFormat('dd MMM yyyy').format(_dateRange!.end)}',
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _remarksController,
//                   decoration: InputDecoration(
//                     labelText: 'Keterangan',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Aksi ketika tombol kirim ditekan
//                     final idPegawai =
//                         1; // Hardcoded for testing, replace with actual value
//                     final jenisIzin = _selectedPermitType;
//                     final keterangan = _remarksController.text;
//                     final tanggalMulai = _dateRange?.start ?? DateTime.now();
//                     final tanggalAkhir = _dateRange?.end ?? DateTime.now();

//                     // Trigger SubmitPermitEvent
//                     BlocProvider.of<PermitsBloc>(context).add(
//                       SubmitPermitEvent(
//                         idPegawai: idPegawai,
//                         jenisIzin: jenisIzin,
//                         keterangan: keterangan,
//                         tanggalMulai: tanggalMulai,
//                         tanggalAkhir: tanggalAkhir,
//                         dokumen: null, // Add document if necessary
//                       ),
//                     );
//                   },
//                   child: const Text('Kirim'),
//                 ),
//                 BlocListener<PermitsBloc, PermitState>(
//                   listener: (context, state) {
//                     if (state is PermitSubmittedState) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Permohonan Izin Berhasil')),
//                       );
//                     } else if (state is PermitFailure) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(state.message)),
//                       );
//                     }
//                   },
//                   child: Container(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
