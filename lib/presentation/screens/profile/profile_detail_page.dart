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
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'Profil Saya',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileDetails(),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Ubah Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildChangePasswordForm(),
            ],
          ),
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
            TextField(
              controller: _oldPasswordController,
              obscureText: !_isOldPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password Lama',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isOldPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() {
                    _isOldPasswordVisible = !_isOldPasswordVisible;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Kirim',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileCard({
    required String namaPegawai,
    required String noPegawai,
    required String jabatanPegawai,
  }) {
    return Container(
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
          _buildProfileDetailRow('Nama Pegawai:', namaPegawai),
          _buildProfileDetailRow('Nomor Pegawai:', noPegawai),
          _buildProfileDetailRow('Jabatan Pegawai:', jabatanPegawai),
        ],
      ),
    );
  }

  Widget _buildProfileDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildProfileSkeleton() {
    return Container(
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
          _buildSkeletonRow(width: 200, height: 20),
          const SizedBox(height: 20),
          _buildSkeletonRow(width: 150, height: 20),
          const SizedBox(height: 20),
          _buildSkeletonRow(width: 180, height: 20),
        ],
      ),
    );
  }

  Widget _buildSkeletonRow({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
