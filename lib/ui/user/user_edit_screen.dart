import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../shared/dialog_utils.dart';
import 'user_manager.dart';

class EditUserScreen extends StatefulWidget {
  static const routeName = '/edit_user';

  EditUserScreen(
    User? user, {
    super.key,
  }) {
    if (user == null) {
      this.user = User(
        id: null,
        username: '',
        name: '',
        email: '',
        avatarUrl: '',
      );
    } else {
      this.user = user;
    }
  }

  late final User user;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _editForm = GlobalKey<FormState>();
  late User _editedUser;

  @override
  void initState() {
    _editedUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _editForm,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 60),
              _buildAvatarPreview(),
              const SizedBox(height: 40),
              _buildNameField(),
              const SizedBox(height: 20),
              _buildEmailField(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildNameField() {
    return TextFormField(
      initialValue: _editedUser.name,
      decoration: const InputDecoration(labelText: 'Name'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a name.';
        }
        return null;
      },
      onSaved: (value) {
        _editedUser = _editedUser.copyWith(name: value);
      },
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      initialValue: _editedUser.email,
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an email.';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
      onSaved: (value) {
        _editedUser = _editedUser.copyWith(email: value);
      },
    );
  }

  Widget _buildAvatarPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.topRight,
          children: [
            ClipOval(
              child: Container(
                width: 125,
                height: 125,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                child: _editedUser.featuredImage == null
                    ? (_editedUser.avatarUrl.isEmpty
                        ? const Center(child: Text('No Image'))
                        : Image.network(
                            _editedUser.avatarUrl,
                            fit: BoxFit.cover,
                          ))
                    : Image.file(
                        _editedUser.featuredImage!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: TextButton.icon(
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.black,
                ),
                label: const Text(''),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () async {
                  final imagePicker = ImagePicker();
                  try {
                    final imageFile = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (imageFile == null) {
                      return;
                    }
                    _editedUser = _editedUser.copyWith(
                        featuredImage: File(imageFile.path));
                    setState(() {});
                  } catch (error) {
                    if (mounted) {
                      showErrorDialog(context, 'Something went wrong.');
                    }
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Thêm các widget khác nếu cần
      ],
    );
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    try {
      final userManager = context.read<UserManager>();
      if (_editedUser.id != null) {
        await userManager.updateUser(_editedUser);
      }
    } catch (error) {
      if (mounted) {
        await showErrorDialog(context, 'Something went wrong.');
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
