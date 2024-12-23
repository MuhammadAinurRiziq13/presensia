import 'dart:io';

abstract class ProfileEvent {}

class FetchAllDataEvent extends ProfileEvent {}

class ChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent({required this.oldPassword, required this.newPassword});
}

class LogoutEvent extends ProfileEvent {}

class UploadImageEvent extends ProfileEvent {
  final File imageFile;

  UploadImageEvent({required this.imageFile});
}
