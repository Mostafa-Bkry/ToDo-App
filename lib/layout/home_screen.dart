import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ToDoCubit()..databaseCreation(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          ToDoCubit toDoCubit = ToDoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                toDoCubit.titles[toDoCubit.index],
              ),
            ),
            body: ConditionalBuilder(
              builder: (context) => toDoCubit.screens[toDoCubit.index],
              condition: state is! ToDoGetFromDatabaseLoadingState,
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (toDoCubit.isSheetShown) {
                  if (formKey.currentState!.validate()) {
                    toDoCubit.onBottomSheetChanged(false, Icons.add);
                    toDoCubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                      context: context,
                    );
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                    print('records from fab ${toDoCubit.records}');
                  }
                } else {
                  toDoCubit.onBottomSheetChanged(true, Icons.done);
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                commonTextField(
                                  controller: titleController,
                                  validatorFunction: (value) => value!.isEmpty
                                      ? 'Please, Enter Title'
                                      : null,
                                  inputType: TextInputType.text,
                                  labelText: 'Title',
                                  prefixIcon: const Icon(Icons.title),
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                commonTextField(
                                  controller: timeController,
                                  validatorFunction: (value) => value!.isEmpty
                                      ? 'Please, Enter Time'
                                      : null,
                                  inputType: TextInputType.datetime,
                                  labelText: 'Time',
                                  prefixIcon:
                                      const Icon(Icons.watch_later_rounded),
                                  textInputAction: TextInputAction.next,
                                  onTabFun: () => showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  )
                                      .then((value) => timeController.text =
                                          value!.format(context).toString())
                                      .catchError((error) => print(
                                          'Error while picking time: ${error.toString()}')),
                                  isReadOnly: true,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                commonTextField(
                                  controller: dateController,
                                  validatorFunction: (value) => value!.isEmpty
                                      ? 'Please, Enter Date'
                                      : null,
                                  inputType: TextInputType.datetime,
                                  labelText: 'Date',
                                  prefixIcon:
                                      const Icon(Icons.calendar_today_rounded),
                                  textInputAction: TextInputAction.done,
                                  onTabFun: () => showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-12-30'),
                                  )
                                      .then((value) => dateController.text =
                                          DateFormat.yMMMd().format(value!))
                                      .catchError((error) => print(
                                          'Error while picking time: ${error.toString()}')),
                                  isReadOnly: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 50,
                      )
                      .closed
                      .then((value) {
                    toDoCubit.onBottomSheetChanged(false, Icons.add);
                  });
                }
              },
              child: Icon(toDoCubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20.0,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline_rounded),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_rounded),
                  label: 'Archived',
                ),
              ],
              currentIndex: toDoCubit.index,
              onTap: (index) {
                toDoCubit.indexChange(index);
              },
            ),
          );
        },
      ),
    );
  }
}



















// Future<String> getName() async {
//   return 'Ahmed Mohamed';
// }



// () async {
            //   try {
            //     throw ('There is an error !!!');

            //     print(getName());
            //     String name = await getName();
            //     print(name);
            //   } catch (error) {
            //     print('The error: ${error.toString()}');
            //   }
            // }

            //     () {
            //   getName().then((value) {
            //     print(value);
            //     print('Osama');
            //     //the second print will wait until the getName() finishes

            //     throw ('There is an error !!!');
            //   }).catchError((error) {
            //     print('The error is : ${error.toString()}');
            //   });
            // },