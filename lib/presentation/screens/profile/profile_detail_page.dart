import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensia/presentation/blocs/profile/profile_detail_bloc.dart';
import 'package:presensia/presentation/blocs/profile/profile_state.dart';
import 'package:presensia/presentation/blocs/profile/profile_event.dart';
import '../../../core/utils/flushbar_helper.dart';
import 'package:go_router/go_router.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileDetailBloc>().add(FetchAllDataEvent());
  }

  void _changePassword() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;

    if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
      context.read<ProfileDetailBloc>().add(ChangePasswordEvent(
            oldPassword: oldPassword,
            newPassword: newPassword,
          ));
      context.read<ProfileDetailBloc>().add(FetchAllDataEvent());
    } else {
      showErrorFlushbar(context, 'Password tidak boleh kosong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'Profil Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileDetails(),
                const SizedBox(height: 30),
                _buildChangePasswordSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ubah Password',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),
            _buildChangePasswordForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return BlocBuilder<ProfileDetailBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return _buildProfileSkeleton();
        } else if (state is ProfileSuccess) {
          final user = state.user;
          return _buildProfileCard(
            namaPegawai: user.namaPegawai ?? '---',
            noPegawai: user.noPegawai.toString(),
            jabatanPegawai: user.jabatan ?? '---',
          );
        } else {
          return _buildProfileSkeleton();
        }
      },
    );
  }

  Widget _buildChangePasswordForm() {
    return BlocConsumer<ProfileDetailBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfilePasswordChangeFailure) {
          showErrorFlushbar(context, state.errorMessage);
        } else if (state is ProfilePasswordChangeSuccess) {
          showSuccessFlushbar(context, 'Password berhasil diubah!');
          _oldPasswordController.clear();
          _newPasswordController.clear();
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfilePasswordLoading;
        return Column(
          children: [
            _buildPasswordTextField(
              controller: _oldPasswordController,
              label: 'Password Lama',
              isVisible: _isOldPasswordVisible,
              onVisibilityToggle: () => setState(() {
                _isOldPasswordVisible = !_isOldPasswordVisible;
              }),
            ),
            const SizedBox(height: 20),
            _buildPasswordTextField(
              controller: _newPasswordController,
              label: 'Password Baru',
              isVisible: _isNewPasswordVisible,
              onVisibilityToggle: () => setState(() {
                _isNewPasswordVisible = !_isNewPasswordVisible;
              }),
            ),
            const SizedBox(height: 30),
            _buildSubmitButton(isLoading),
          ],
        );
      },
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: TextStyle(color: Colors.black), // Text color set to black
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue),
        filled: true,
        fillColor: Colors.blue.shade50.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _changePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                'Kirim',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String namaPegawai,
    required String noPegawai,
    required String jabatanPegawai,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Profil',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),
            _buildProfileDetailRow('Nama Pegawai    :', namaPegawai),
            _buildProfileDetailRow('Nomor Pegawai   :', noPegawai),
            _buildProfileDetailRow('Jabatan Pegawai :', jabatanPegawai),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // Text color set to black
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSkeleton() {
    return Column(
      children: [
        _buildProfileCard(
          namaPegawai: 'Loading...',
          noPegawai: 'Loading...',
          jabatanPegawai: 'Loading...',
        ),
      ],
    );
  }
}
