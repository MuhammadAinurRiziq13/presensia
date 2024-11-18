import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/login/login_event.dart';
import '../../blocs/login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/flushbar_helper.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _noPegawaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  String? _noPegawaiError; // Error untuk Nomor Pegawai
  String? _passwordError; // Error untuk Password

  @override
  void dispose() {
    _noPegawaiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  // Memeriksa status registrasi dari SharedPreferences
  void _checkRegistrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isRegistered = prefs.getBool('isRegistered') ?? false;

    if (isRegistered) {
      // Jika registrasi berhasil, tampilkan Flushbar sukses
      showSuccessFlushbar(
          context, 'Pendaftaran berhasil! Selamat datang di aplikasi!');

      // Setelah Flushbar ditampilkan, reset status registrasi
      prefs.setBool('isRegistered', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (mounted) {
            SharedPreferences.getInstance().then((prefs) {
              prefs.setBool('isLogined', true);
            });
            context.go('/home'); // Navigate to home
          }
        } else if (state is LoginFailure) {
          // Set error for Flushbar only if it's the login failure message
          if (state.errorMessage
              .contains('Nomor pegawai atau password salah')) {
            // Show error via Flushbar only
            showErrorFlushbar(context, state.errorMessage);

            // Reset TextField errors to null
            setState(() {
              _noPegawaiError = null;
              _passwordError = null;
            });
          } else {
            // Handle other errors, for example show them in TextField
            setState(() {
              if (state.errorMessage.contains('Nomor pegawai')) {
                _noPegawaiError = state.errorMessage;
                _passwordError = null;
              } else if (state.errorMessage.contains('Password')) {
                _passwordError = state.errorMessage;
                _noPegawaiError = null;
              } else {
                _noPegawaiError = state.errorMessage;
                _passwordError = state.errorMessage;
              }
            });

            // Optionally show the general errors in Flushbar too
            showErrorFlushbar(context, state.errorMessage);
          }
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
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Silahkan Login untuk melanjutkan',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    // Nomor Pegawai TextField
                    TextField(
                      controller: _noPegawaiController,
                      cursorColor: Colors.blue,
                      enabled: !(state is LoginLoading),
                      decoration: InputDecoration(
                        labelText: 'Nomor Pegawai',
                        labelStyle: const TextStyle(color: Colors.grey),
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                        errorText: _noPegawaiError, // Tampilkan error
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password TextField
                    TextField(
                      controller: _passwordController,
                      cursorColor: Colors.blue,
                      obscureText: _isObscure,
                      enabled: !(state is LoginLoading),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                        errorText: _passwordError, // Tampilkan error
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: const Text(
                          'Lupa password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Login Button with full width
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                                final noPegawai =
                                    _noPegawaiController.text.trim();
                                final password =
                                    _passwordController.text.trim();

                                // Validasi input
                                if (noPegawai.isEmpty) {
                                  setState(() {
                                    _noPegawaiError =
                                        'Nomor Pegawai tidak boleh kosong';
                                    _passwordError = null;
                                  });
                                  return;
                                }

                                if (int.tryParse(noPegawai) == null) {
                                  setState(() {
                                    _noPegawaiError =
                                        'Nomor Pegawai harus berupa angka';
                                    _passwordError = null;
                                  });
                                  return;
                                }

                                if (password.isEmpty) {
                                  setState(() {
                                    _passwordError =
                                        'Password tidak boleh kosong';
                                    _noPegawaiError = null;
                                  });
                                  return;
                                }

                                if (password.length < 6) {
                                  setState(() {
                                    _passwordError =
                                        'Password minimal 6 karakter';
                                    _noPegawaiError = null;
                                  });
                                  return;
                                }

                                setState(() {
                                  _noPegawaiError = null;
                                  _passwordError = null;
                                });

                                context.read<LoginBloc>().add(
                                      LoginButtonPressed(
                                        noPegawai: noPegawai,
                                        password: password,
                                      ),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: state is LoginLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun?"),
                        TextButton(
                          onPressed: () {
                            context.go('/register');
                          },
                          child: const Text(
                            "Daftar Disini",
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
