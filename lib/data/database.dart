import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    toList = [
      ["Hello", false],
      ["Wellcome to our app", false],
    ];
  }

  // load the data from database
  void loadData() {
    toList = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toList);
  }
}
