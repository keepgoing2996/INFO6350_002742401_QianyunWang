import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:instgram_flutter/models/sale_item_url.dart';
import 'package:instgram_flutter/widgets/image_input.dart';
import 'package:instgram_flutter/resources/filestore_methods.dart';
import 'package:instgram_flutter/models/user.dart';
import 'package:provider/provider.dart';
import 'package:instgram_flutter/providers/user_provider.dart';

class NewPostActivity extends StatefulWidget {
  const NewPostActivity({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewPostActivityState();
  }
}

class _NewPostActivityState extends State<NewPostActivity> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  File? _selectedImage2;
  var _enteredName = '';
  var _enteredPrice = 0.0;
  var _enteredDescription = '';
  bool _isLoading = false;

  void _saveItem(String uid, String username, String profImage) async {
    if (_selectedImage == null || _selectedImage2 == null) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      String res = await FireStoreMethods().uploadSaleItem(
        id: DateTime.now().toString(),
        name: _enteredName,
        price: _enteredPrice,
        description: _enteredDescription,
        image: _selectedImage!,
        image2: _selectedImage2!,
        uid: uid,
        username: username,
        profImage: profImage,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Sale Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : Padding(padding: EdgeInsets.only(top: 0)),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title of the item'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Price'),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _enteredPrice.toString(),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null ||
                        double.tryParse(value)! <= 0.0) {
                      return 'not a valid numbers';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPrice = double.parse(value!);
                  }),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('description of the item'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'must be not empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredDescription = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageInput(
                    onPickImage: (image) {
                      _selectedImage = image;
                    },
                  ),
                  ImageInput(
                    onPickImage: (image) {
                      _selectedImage2 = image;
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset Text'),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _saveItem(user!.uid, user.username, user.photoUrl),
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
