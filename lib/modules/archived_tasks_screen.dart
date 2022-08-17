import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.separated(
            itemBuilder: (context, index) => taskItem(
                  record: ToDoCubit.get(context).archivedRecords[index],
                  context: context,
                ),
            separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      8.0, 10.0, 0.0, 10.0),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
            itemCount: ToDoCubit.get(context).archivedRecords.length),
      ),
    );
  }
}
