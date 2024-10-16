import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class PermitRequestPage extends StatefulWidget {
  @override
  _PermitRequestPageState createState() => _PermitRequestPageState();
}

class _PermitRequestPageState extends State<PermitRequestPage> {
  String _selectedPermitType = 'Cuti'; // Default tipe izin
  DateTimeRange? _selectedDateRange; // Menyimpan range tanggal
  TextEditingController _remarksController = TextEditingController(); // Kontrol untuk input keterangan

  // Fungsi untuk memilih range tanggal
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perizinan'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Jenis Perizinan (dengan border abu-abu)
                // Column yang berisi RadioListTile
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Mengurangi padding vertikal
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0), // Kurangi padding bawah untuk merapatkan label
                        child: Text(
                          "Silahkan Pilih :",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero, // Hilangkan padding bawaan
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4), // Rapatkan vertikal
                        title: const Text('Sakit'),
                        value: 'Sakit',
                        groupValue: _selectedPermitType,
                        activeColor: Colors.blue,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPermitType = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero, // Hilangkan padding bawaan
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4), // Rapatkan vertikal
                        title: const Text('Cuti'),
                        value: 'Cuti',
                        groupValue: _selectedPermitType,
                        activeColor: Colors.blue,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPermitType = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero, // Hilangkan padding bawaan
                        visualDensity: VisualDensity(horizontal: 0, vertical: -4), // Rapatkan vertikal
                        title: const Text('WFA (Work From Anywhere)'),
                        value: 'WFA',
                        groupValue: _selectedPermitType,
                        activeColor: Colors.blue,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPermitType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Kondisi untuk tampilan sesuai jenis izin
                if (_selectedPermitType == 'Sakit') ...[
                  // Input Keterangan (untuk izin Sakit)
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Keterangan',
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelStyle: const TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Unggah Dokumen
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logika untuk mengunggah dokumen
                    },
                    icon: Icon(Icons.upload_file),
                    label: Text('Unggah Dokumen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18), // Tambahkan padding vertikal
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else ...[
                  // Input tanggal dan keterangan untuk Cuti dan WFH
                  GestureDetector(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey), // Add grey border
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDateRange == null
                                    ? 'Pilih Tanggal'
                                    : '${DateFormat('dd MMM yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM yyyy').format(_selectedDateRange!.end)}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.edit, color: Colors.blue),
                            ],
                          ),
                          SizedBox(height: 10),
                          _selectedDateRange == null
                              ? Text('Tanggal Mulai - Tanggal Akhir', style: TextStyle(color: Colors.grey))
                              : CalendarDateRangeWidget(dateRange: _selectedDateRange!)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Input Keterangan
                  TextField(
                    controller: _remarksController,
                    decoration: InputDecoration(
                      labelText: 'Keterangan',
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelStyle: const TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Tombol Kirim
                ElevatedButton(
                  onPressed: () {
                    // Aksi ketika tombol kirim ditekan
                  },
                  child: Text(
                    'Kirim',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget untuk menampilkan range tanggal pada kalender
class CalendarDateRangeWidget extends StatelessWidget {
  final DateTimeRange dateRange;

  const CalendarDateRangeWidget({required this.dateRange});

  @override
  Widget build(BuildContext context) {
    // Extracting the start and end date
    DateTime startDate = dateRange.start;
    DateTime endDate = dateRange.end;

    // Formatting months
    String startMonth = DateFormat('MMMM').format(startDate); // e.g. "January"
    String endMonth = DateFormat('MMMM').format(endDate); // e.g. "February"

    // Calculate total number of days in the range
    int daysCount = endDate.difference(startDate).inDays + 1; // Include the start day

    // Prepare the display text
    String displayText;
    if (startMonth == endMonth) {
      displayText = '$startMonth (${daysCount} hari)'; // Same month
    } else {
      displayText = '$startMonth - $endMonth (${daysCount} hari)'; // Different months
    }

    return Text(
      displayText,
      style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
    );
  }
}
