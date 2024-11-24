import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/register/register_bloc.dart';
import '../../blocs/register/register_event.dart';
import '../../blocs/register/register_state.dart';
import '../../../core/utils/flushbar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  final _noPegawaiController = TextEditingController();
  final _noHpController = TextEditingController();
  final _alamatController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _noPegawaiError;
  String? _noHpError;
  String? _alamatError;
  String? _passwordError;

  @override
  void dispose() {
    _noPegawaiController.dispose();
    _noHpController.dispose();
    _alamatController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _resetErrors() {
    setState(() {
      _noPegawaiError = null;
      _noHpError = null;
      _alamatError = null;
      _passwordError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setBool('isRegistered', true);
          });

          // Navigasi ke halaman login
          context.go('/login');
        } else if (state is RegisterFailure) {
          setState(() {
            if (state.errorMessage.contains('Nomor pegawai')) {
              _noPegawaiError = state.errorMessage;
            } else if (state.errorMessage.contains('No Telpon')) {
              _noHpError = state.errorMessage;
            } else if (state.errorMessage.contains('Alamat')) {
              _alamatError = state.errorMessage;
            } else if (state.errorMessage.contains('Password')) {
              _passwordError = state.errorMessage;
            }
          });

          // Tampilkan Flushbar error
          showErrorFlushbar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
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
                    Image.asset(
                      'images/logo.png',
                      width: 100.0,
                      height: 100.0,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Daftar Akun',
                      style: TextStyle(
                        fontSize: 33.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Buat akun baru untuk melanjutkan',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _noPegawaiController,
                      cursorColor: Colors.blue,
                      enabled: !(state is RegisterLoading),
                      decoration: InputDecoration(
                        labelText: 'Nomor Pegawai',
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                        errorText: _noPegawaiError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _alamatController,
                      cursorColor: Colors.blue,
                      enabled: !(state is RegisterLoading),
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                        errorText: _alamatError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _noHpController,
                      cursorColor: Colors.blue,
                      enabled: !(state is RegisterLoading),
                      decoration: InputDecoration(
                        labelText: 'No Telpon',
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                        errorText: _noHpError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      cursorColor: Colors.blue,
                      enabled: !(state is RegisterLoading),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                        errorText: _passwordError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is RegisterLoading
                            ? null
                            : () {
                                _resetErrors();
                                final noPegawai =
                                    _noPegawaiController.text.trim();
                                final alamat = _alamatController.text.trim();
                                final noHp = _noHpController.text.trim();
                                final password =
                                    _passwordController.text.trim();

                                if (noPegawai.isEmpty) {
                                  setState(() {
                                    _noPegawaiError =
                                        'Nomor Pegawai tidak boleh kosong';
                                  });
                                  return;
                                }
                                if (int.tryParse(noPegawai) == null) {
                                  setState(() {
                                    _noPegawaiError =
                                        'Nomor Pegawai harus berupa angka';
                                  });
                                  return;
                                }
                                if (alamat.isEmpty) {
                                  setState(() {
                                    _alamatError = 'Alamat tidak boleh kosong';
                                  });
                                  return;
                                }
                                if (noHp.isEmpty) {
                                  setState(() {
                                    _noHpError =
                                        'Nomor Telepon tidak boleh kosong';
                                  });
                                  return;
                                }
                                if (password.isEmpty) {
                                  setState(() {
                                    _passwordError =
                                        'Password tidak boleh kosong';
                                  });
                                  return;
                                }
                                if (password.length < 6) {
                                  setState(() {
                                    _passwordError =
                                        'Password minimal 6 karakter';
                                  });
                                  return;
                                }

                                context.read<RegisterBloc>().add(
                                      RegisterButtonPressed(
                                        noPegawai: noPegawai,
                                        alamat: alamat,
                                        noHp: noHp,
                                        password: password,
                                      ),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: state is RegisterLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Daftar',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun?"),
                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          child: const Text(
                            "Login Disini",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
