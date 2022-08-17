import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/archived_tasks_screen.dart';
import '../../modules/done_tasks_screen.dart';
import '../../modules/new_tasks_screen.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  int index = 0;

  final List<Widget> screens = const [
    NewTaskScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  final List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  Database? database;
  List<Map> newRecords = [];
  List<Map> doneRecords = [];
  List<Map> archivedRecords = [];
  IconData fabIcon = Icons.add;
  bool isSheetShown = false;

  ToDoCubit() : super(ToDoInitialState());

  static ToDoCubit get(context) => BlocProvider.of(context);

  void indexChange(int index) {
    this.index = index;
    emit(ToDoBottomNavBarState());
  }

  //Database Methods

  void databaseCreation() async {
    await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('ToDo Database is created');
        db
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)')
            .then((value) => print('Tasks table is created'))
            .catchError((error) =>
                print('Error when creating Tasks table: ${error.toString()}'));
      },
      onOpen: (db) {
        print('ToDo Databse is opened');
        getDataFromDatabase(db);
      },
    )
        .then((value) => database = value)
        .catchError((error) => print('Error while opening database ${error}'));
    //print(records);
  }

  void insertToDatabase({
    required String title,
    required String time,
    required String date,
    required BuildContext context,
  }) async {
    await database?.transaction(
      (txn) => txn
          .rawInsert(
              'INSERT INTO Tasks(title, time, date, status) VALUES("$title","$time","$date","new")')
          .then(
        (value) {
          emit(ToDoDatabaseInsertionState());
          Navigator.pop(context);
          getDataFromDatabase(database!);
        },
      ).catchError(
        (error) => print(
            'Error when inserting new record to Tasks table: ${error.toString()}'),
      ),
    );
  }

  void getDataFromDatabase(Database database) {
    newRecords = [];
    doneRecords = [];
    archivedRecords = [];
    emit(ToDoGetFromDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      print(value);
      value.forEach(
        (element) {
          if (element['status'] == 'new') {
            newRecords.add(element);
            print('new: $element');
          } else if (element['status'] == 'updated done') {
            doneRecords.add(element);
            print('done: $element');
          } else {
            archivedRecords.add(element);
            print('arch: $element');
          }
        },
      );
      emit(ToDoGetFromDatabaseState());
      //print('the value: $value');
      ////// setState(() {
      //   records = value;
      // });
      //print('records: $records');
    }).catchError((error) =>
        print('Error when getting records from Tasks table: ${error}'));
  }

  void updateDatabase({
    required String status,
    required int id,
  }) {
    database?.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      ['updated $status', id],
    ).then(
      (value) {
        getDataFromDatabase(database!);
        emit(ToDoUpdateDatabaseState());
      },
    );
  }

  void onBottomSheetChanged(bool isSheetShown, IconData fabIcon) {
    //print(records);
    this.isSheetShown = isSheetShown;
    this.fabIcon = fabIcon;
    emit(ToDoBottomSheetChangeState());
  }
}
