import 'package:flutter/material.dart';
import 'package:parking_system/models/user.dart';
import 'package:parking_system/services/user_auth.dart';
import 'package:parking_system/utils/AccountDataValidator.dart';
import 'package:parking_system/utils/Utils.dart';

class ChangePasswordDialog extends StatefulWidget {
  final UserDb user;
  final Function(String) onChanged;

  ChangePasswordDialog({required this.onChanged, required this.user});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final UserAuth _userAuth = UserAuth();
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Change Password',
        style: TextStyle(color: Colors.white60),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.white60),
            obscureText: true,
            controller: _oldPasswordController,
            decoration: const InputDecoration(labelText: 'Old Password'),
          ),
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.white60),
            obscureText: true,
            controller: _newPasswordController,
            decoration: const InputDecoration(labelText: 'New password'),
          ),
          const SizedBox(height: 10),
          TextField(
            style: const TextStyle(color: Colors.white60),
            obscureText: true,
            controller: _confirmNewPasswordController,
            decoration:
                const InputDecoration(labelText: 'Confirm new password'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_newPasswordController.text !=
                _confirmNewPasswordController.text) {
              showToast('Passwords don\'t match');
              return;
            }
            if (!AccountDataValidator.validatePassword(
                _newPasswordController.text)) {
              showToast('Password too weak');
              return;
            }
            //add check old password if matches

            _userAuth.changePassword(widget.user.login,
                _oldPasswordController.text, _newPasswordController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
