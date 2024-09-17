import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox(
      {required this.controller, required this.onSave, required this.onCancel});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content:
          Form(
            key: _formKey,
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'Add a new task',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: _border,
                  focusedBorder: _border,
                  border: _border),
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Please enter your task';
                }else{
                  return null;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel',
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState?.validate() == true){
                    onSave();
                  }
                },
                child: Text('Save'),
              ),
            )
          ],
        ),
      ],
    );
  }
}

final _border= OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(
        color: Colors.white, width: 1) // Rounded corners
);

