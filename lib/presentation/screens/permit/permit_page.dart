import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../blocs/permit/permit_bloc.dart';
import '../../blocs/permit/permit_event.dart';
import '../../blocs/permit/permit_state.dart';
import 'package:image_picker/image_picker.dart';

class PermitPage extends StatefulWidget {
  @override
  _PermitPageState createState() => _PermitPageState();
}

class _PermitPageState extends State<PermitPage> {
  File? _dokumen;
  final _formKey = GlobalKey<FormState>();
  String _jenisIzin = '';
  String _keterangan = '';
  DateTime _tanggalMulai = DateTime.now();
  DateTime _tanggalAkhir = DateTime.now().add(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perizinan'),
      ),
      body: Column(
        children: [
          // Menu Pilihan (Perizinan atau Riwayat Perizinan)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Menampilkan form Perizinan untuk input izin
                    context
                        .read<PermitBloc>()
                        .add(GetPermitsEvent(1)); // Misalnya ID pegawai = 1
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Perizinan'),
                        content: _buildPerizinanForm(),
                      ),
                    );
                  },
                  child: Text('Perizinan'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Menampilkan riwayat perizinan
                    context
                        .read<PermitBloc>()
                        .add(GetPermitsEvent(1)); // Misalnya ID pegawai = 1
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Riwayat Perizinan'),
                        content: _buildRiwayatPerizinanList(),
                      ),
                    );
                  },
                  child: Text('Riwayat Perizinan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Form untuk mengisi data izin
  Widget _buildPerizinanForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Jenis Izin'),
            onChanged: (value) {
              setState(() {
                _jenisIzin = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Keterangan'),
            onChanged: (value) {
              setState(() {
                _keterangan = value;
              });
            },
          ),
          ListTile(
            title: Text('Tanggal Mulai: ${_tanggalMulai.toLocal()}'),
            trailing: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _tanggalMulai,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _tanggalMulai)
                  setState(() {
                    _tanggalMulai = pickedDate;
                  });
              },
            ),
          ),
          ListTile(
            title: Text('Tanggal Akhir: ${_tanggalAkhir.toLocal()}'),
            trailing: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _tanggalAkhir,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _tanggalAkhir)
                  setState(() {
                    _tanggalAkhir = pickedDate;
                  });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);

              if (pickedFile != null) {
                setState(() {
                  _dokumen = File(pickedFile.path);
                });
              }
            },
            child: Text('Pilih Dokumen (Opsional)'),
          ),
          ElevatedButton(
            onPressed: () {
              // Kirim event untuk submit izin
              context.read<PermitBloc>().add(SubmitPermitEvent(
                    idPegawai: 1, // Misalnya ID pegawai = 1
                    jenisIzin: _jenisIzin,
                    keterangan: _keterangan,
                    tanggalMulai: _tanggalMulai,
                    tanggalAkhir: _tanggalAkhir,
                    dokumen: _dokumen,
                  ));
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  // Menampilkan riwayat perizinan
  Widget _buildRiwayatPerizinanList() {
    return BlocBuilder<PermitBloc, PermitState>(
      builder: (context, state) {
        if (state is PermitLoadingState) {
          return CircularProgressIndicator();
        } else if (state is PermitLoadedState) {
          final permits = state.permits;
          return ListView.builder(
            itemCount: permits.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(permits[index].jenisIzin),
                subtitle: Text('Status: ${permits[index].statusIzin}'),
                trailing:
                    Text(permits[index].tanggalMulai.toLocal().toString()),
              );
            },
          );
        } else if (state is PermitErrorState) {
          return Text('Error: ${state.message}');
        }
        return Container();
      },
    );
  }
}




// import 'package:flutter/material.dart';
// import '../history/permit_history_page.dart';
// import 'permit_request_page.dart'; // Import the PermitRequestPage

// class PermitPage extends StatefulWidget {
//   const PermitPage({super.key});

//   @override
//   _PermitPageState createState() => _PermitPageState();
// }

// class _PermitPageState extends State<PermitPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Perizinan',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: const Icon(Icons.mail_outline, color: Colors.blue),
//                     title: const Text('Ajukan Perizinan'),
//                     trailing: const Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PermitRequestPage(),
//                         ),
//                       );
//                     },
//                   ),
//                   const Padding(
//                     padding:
//                         EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                     child: Divider(height: 1, thickness: 1),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.history, color: Colors.blue),
//                     title: const Text('Riwayat Perizinan'),
//                     trailing: const Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PermitHistoryPage(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }