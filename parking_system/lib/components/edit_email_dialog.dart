import 'package:flutter/material.dart';

class ChangeEmailDialog extends StatefulWidget {
  final String currentEmail;
  final Function(String) onChanged;

  ChangeEmailDialog({required this.currentEmail, required this.onChanged});

  @override
  _ChangeEmailDialogState createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.currentEmail);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Change Email',
        style: TextStyle(color: Colors.white60),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter the new email:',
              style: TextStyle(color: Colors.amberAccent)),
          const SizedBox(height: 10),
          TextField(
            style: TextStyle(color: Colors.white60),
            controller: _emailController,
            decoration: InputDecoration(labelText: 'New Email'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Get the new email from the TextField
            String newEmail = _emailController.text;

            // Call the onChanged callback to update the email
            widget.onChanged(newEmail);

            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
