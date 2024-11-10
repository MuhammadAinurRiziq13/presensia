import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: const [
                Text(
                  'Jika Anda memiliki pertanyaan, silakan hubungi kami di: support@presensia.com',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                // Navigasi ke halaman baru ketika kontainer di klik
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12), // Padding dalam kontainer
                decoration: BoxDecoration(
                  color: Colors.blue, // Warna latar belakang kontainer
                  borderRadius: BorderRadius.circular(
                      8), // Membuat sudut kontainer melengkung
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min, // Ukuran baris minimum
                  children: [
                    Icon(Icons.contact_phone, color: Colors.white), // Ikon
                    SizedBox(width: 8), // Spasi antara ikon dan teks
                    Text(
                      'Hubungi Kami',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16), // Warna dan ukuran teks
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Masalah'),
        backgroundColor: Colors.white, // Warna latar belakang app bar
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul Masalah:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan judul permasalahan',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Keterangan Masalah:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Jelaskan masalah yang Anda alami',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
