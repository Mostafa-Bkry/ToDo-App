import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

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

Widget taskItem({
  required Map record,
  required BuildContext context,
}) {
  return Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: Text(record['time']),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record['title'],
              style: const TextStyle(
                letterSpacing: 2,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              record['date'],
              style: const TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: () {
          ToDoCubit.get(context)
              .updateDatabase(status: 'done', id: record['id']);
        },
        icon: Icon(
          Icons.check_box,
          color: Colors.red[700],
        ),
      ),
      IconButton(
        onPressed: () {
          ToDoCubit.get(context)
              .updateDatabase(status: 'archived', id: record['id']);
        },
        icon: Icon(
          Icons.archive,
          color: Colors.grey[500],
        ),
      ),
    ],
  );
}
