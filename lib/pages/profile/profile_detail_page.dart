import 'package:flutter/material.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nama Pegawai:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Anomalia',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nomor Pegawai:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '2241720100',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Jabatan Pegawai:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mobile Developer',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                const Text(
                  'Ubah Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Input Password Lama
                TextField(
                  controller: _oldPasswordController,
                  obscureText: !_isOldPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password Lama',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isOldPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isOldPasswordVisible = !_isOldPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Input Password Baru
                TextField(
                  controller: _newPasswordController,
                  obscureText: !_isNewPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Tombol Kirim
                SizedBox(
                  width: double.infinity, // Tombol memenuhi layar
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika untuk mengirim password baru ke server
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue, // Warna tombol biru
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Samakan pojokan tombol
                      ),
                    ),
                    child: const Text(
                      'Kirim',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
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
