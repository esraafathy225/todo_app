import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_todo_app/components/dialog_box.dart';
import 'package:new_todo_app/components/todo_tile.dart';
import 'package:new_todo_app/data/database.dart';

import '../data/models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  List<TodoModel> todoList = [];

  final _myBox = Hive.box<TodoModel>('todoBox');
  var todoDatabase = TodoDatabase();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_myBox.isNotEmpty) {
      todoList = todoDatabase.loadTodos();
    }
  }

  void onCheckboxChanged(bool? value, int index) {
    setState(() {
      todoList[index].isCompleted = !todoList[index].isCompleted;
      _myBox.putAt(index, todoList[index]); // Update the task in Hive
    });
  }

  void saveNewTask() {
    setState(() {
      var newTask = TodoModel(title: _controller.text, isCompleted: false);
      todoList.add(newTask);
      todoDatabase.addTodo(newTask);
    });
    _controller.clear();
    Navigator.pop(context);
  }

  void cancelDialog() {
    _controller.clear();
    Navigator.pop(context);
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: cancelDialog,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(color: Colors.white),
        ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settingspage');
                },
                icon: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.settings,
                      size: 24,
                    ),
                  ),
                ))
          ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(todoList[index].title),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                todoList.removeAt(index);
                _myBox.deleteAt(index); // Remove the task from Hive
              });
            },
            child: TodoTile(
              taskName: todoList[index].title,
              taskCompleted: todoList[index].isCompleted,
              onChanged: (value) => onCheckboxChanged(value, index),
            ),
          );
        },
      ),
    );
  }
}