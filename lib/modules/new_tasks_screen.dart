import 'package:flutter/material.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.separated(
          itemBuilder: (context, index) => taskItem(index: index),
          separatorBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8.0, 10.0, 0.0, 10.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
          itemCount: records.length),
    );
  }
}
