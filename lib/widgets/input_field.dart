import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  const InputField(
      {Key? key,
      required this.icon,
      required this.hint,
      required this.obscure,
      required this.stream,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              errorText: snapshot.hasError ? '$snapshot.error' : null,
              contentPadding:
                  const EdgeInsets.only(left: 5, top: 20, bottom: 20, right: 20),
              icon: Icon(
                icon,
                color: Colors.grey,
              ),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent)),
            ),
            style: const TextStyle(color: Colors.blueAccent),
            obscureText: obscure,
          );

        });
  }
}
