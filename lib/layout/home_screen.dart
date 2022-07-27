import 'package:flutter/material.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[index],
        ),
      ),
      body: screens[index],
      floatingActionButton: FloatingActionButton(
        onPressed:
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

            () {
          getName().then((value) {
            print(value);
            print('Osama');
            //the second print will wait until the getName() finishes

            throw ('There is an error !!!');
          }).catchError((error) {
            print('The error is : ${error.toString()}');
          });
        },
        child: const Icon(
          Icons.add,
        ),
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
}

Future<String> getName() async {
  return 'Ahmed Mohamed';
}
