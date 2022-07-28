import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int index = 0;
  List<Widget> screens = const [
    NewTaskScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  Database? database;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool isSheetShown = false;
  IconData fabIcon = Icons.add;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseCreation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          titles[index],
        ),
      ),
      body: ConditionalBuilder(
        builder: (context) => screens[index],
        condition: records.isNotEmpty,
        fallback: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isSheetShown) {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context);
              // setState(() {
              //   fabIcon = Icons.add;
              // });
              isSheetShown = false;
              insertToDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text,
              ).then((value) {
                getDataFromDatabase(database!).then((value) {
                  setState(() {
                    fabIcon = Icons.add;
                    records = value;
                  });
                }).catchError((error) => print(
                    'Error when getting records from Tasks table: ${error.toString()}'));
              });
              titleController.clear();
              timeController.clear();
              dateController.clear();
              print('records from fab $records');
            }
          } else {
            setState(() {
              fabIcon = Icons.done;
            });
            isSheetShown = true;
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
                            validatorFunction: (value) =>
                                value!.isEmpty ? 'Please, Enter Title' : null,
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
                            validatorFunction: (value) =>
                                value!.isEmpty ? 'Please, Enter Time' : null,
                            inputType: TextInputType.datetime,
                            labelText: 'Time',
                            prefixIcon: const Icon(Icons.watch_later_rounded),
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
                            validatorFunction: (value) =>
                                value!.isEmpty ? 'Please, Enter Date' : null,
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
              setState(() {
                fabIcon = Icons.add;
              });
              isSheetShown = false;
            });
          }
        },
        child: Icon(fabIcon),
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
        currentIndex: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }

  void databaseCreation() async {
    database =
        await openDatabase('todo.db', version: 1, onCreate: (db, version) {
      print('ToDo Database is created');
      db
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
          .then((value) => print('Tasks table is created'))
          .catchError((error) =>
              print('Error when creating Tasks table: ${error.toString()}'));
    }, onOpen: (db) {
      print('ToDo Databse is opened');
      getDataFromDatabase(db).then((value) {
        //print('the value: $value');
        setState(() {
          records = value;
        });
        //print('records: $records');
      }).catchError((error) => print(
          'Error when getting records from Tasks table: ${error.toString()}'));
    });
    //print(records);
  }

  Future<void> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database?.transaction((txn) => txn
        .rawInsert(
            'INSERT INTO Tasks(title, time, date, status) VALUES("$title","$time","$date","new")')
        .then((value) => print('$value is inserted successfully'))
        .catchError((error) => print(
            'Error when inserting new record to Tasks table: ${error.toString()}')));
  }

  Future<List<Map>> getDataFromDatabase(Database database) async =>
      await database.rawQuery('SELECT * FROM Tasks');
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