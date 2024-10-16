import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File handling
import '../app.dart'; // Import halaman Home
import '../register/register.dart'; // Import halaman register
import '../../widgets/custom_button.dart'; // Import widget kustom

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _getImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Menyimpan gambar dari kamera
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40),
                Image.asset('images/logo.png', width: 100.0, height: 100.0),
                const SizedBox(height: 20),
                RichText(
                  text: const TextSpan(
                    text: 'Selamat Datang 👋\nDi ',
                    style: TextStyle(
                      fontSize: 33.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Presensia',
                          style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Silahkan Login untuk melanjutkan',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                const SizedBox(height: 30),
                _buildTextField('Nomor Pegawai', false),
                const SizedBox(height: 20),
                _buildTextField('Password', true),
                const SizedBox(height: 10),
                _buildForgotPasswordButton(),
                const SizedBox(height: 10),
                _buildLoginButtons(),
                const SizedBox(height: 20),
                _buildRegisterButton(),
                const SizedBox(height: 20),
                if (_image != null)
                  Image.file(_image!,
                      height: 200), // Menampilkan gambar hasil capture
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(String label, bool obscure) {
    return TextField(
      obscureText: obscure && _isObscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.blue),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: obscure
            ? IconButton(
                icon:
                    Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }

  Align _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {},
        child:
            const Text('Lupa password?', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  Row _buildLoginButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomButton(
            title: 'Masuk',
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => App()));
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _getImageFromCamera, // Aksi saat tombol kamera ditekan
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.blue,
          ),
          child: const Icon(Icons.camera_alt, color: Colors.white),
        ),
      ],
    );
  }

  Row _buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Belum punya akun?"),
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
          child:
              const Text("Daftar Disini", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
