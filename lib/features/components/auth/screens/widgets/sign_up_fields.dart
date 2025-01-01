import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';

class SignUpFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;

  const SignUpFields({
    super.key,
    required this.nameController,
    required this.surnameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: LocaleKeys.auth_name.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: surnameController,
          decoration: InputDecoration(
            labelText: LocaleKeys.auth_lastName.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
