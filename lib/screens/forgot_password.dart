import 'package:flutter/material.dart';
import 'package:sportal/widgets/ktext_form_field.dart';
import 'package:sportal/widgets/rectangle_button.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Enter your phone number registered for your account to reset your password',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 15,
          ),
          KTextFormField(
            controller: phoneController,
            labelText: 'Phone Number',
          ),
          const SizedBox(
            height: 20,
          ),
          RectangleButton(text: 'Send', onPressed: () {}),
        ]),
      ),
    );
  }
}
