import 'package:flutter/material.dart';

Widget commonTextField({
  required TextEditingController controller,
  required String? Function(String? value)? validatorFunction,
  required TextInputType inputType,
  required String labelText,
  TextStyle lableStyle = const TextStyle(fontSize: 18),
  required Widget prefixIcon,
  TextInputAction textInputAction = TextInputAction.next,
  bool isFilled = false,
  Color fillColor = const Color.fromARGB(255, 238, 239, 247),
  bool isObsecured = false,
  Widget? suffixIcon,
  Function()? onTabFun,
  bool isReadOnly = false,
}) =>
    TextFormField(
      controller: controller,
      validator: validatorFunction,
      keyboardType: inputType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: lableStyle,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
        filled: isFilled,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
      ),
      obscureText: isObsecured,
      onTap: onTabFun,
      readOnly: isReadOnly,
    );

Widget taskItem({required List<Map> record, required int index}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: Text(record[index]['time']),
      ),
      const SizedBox(
        width: 10,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record[index]['title'],
            style: const TextStyle(
              letterSpacing: 2,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            record[index]['date'],
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    ],
  );
}
