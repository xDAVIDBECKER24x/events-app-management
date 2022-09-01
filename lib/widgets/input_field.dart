import 'package:flutter/material.dart';


class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final String? label;
  final Stream<String> stream;
  final Function(String) onChanged;


  const InputField(
      {Key? key,
      required this.label,
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
             style: TextStyle(color: Colors.grey),
             onChanged: onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                errorText: snapshot.hasError ? '${snapshot.error}' : null,
                contentPadding:
                const EdgeInsets.only(left: 5, top: 20, bottom: 20, right: 20),
                prefixIcon: Icon(
                  icon,
                  color: Colors.grey,
                ),
                labelText: label,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.grey,
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amberAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              obscureText: obscure,
            );

          });

  }
}
