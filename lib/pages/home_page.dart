import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoflutter/Components/todo_tile.dart';
import 'package:todoflutter/Themes/theme_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Components/dialog_box.dart';
import '../data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _anime = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> animation = CurvedAnimation(
    parent: _anime,
    curve: Curves.decelerate,
  );
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void dispose() {
    _anime.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toList[index][1] = !db.toList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModal themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              'ToDo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.red,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                _displayBottomSheet(context);
              },
              child: const Icon(
                Icons.info,
                size: 28,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  },
                  icon: Icon(themeNotifier.isDark
                      ? Icons.wb_sunny
                      : Icons.bedtime_rounded))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: createNewTask,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: db.toList.length,
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        taskName: db.toList[index][0],
                        taskCompleted: db.toList[index][1],
                        onChanged: (value) => checkBoxChanged(value, index),
                        deleteFunction: (context) => deleteTask(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 250,
        child: Column(children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const SizedBox(
            height: 10,
          ),
          FadeTransition(
            opacity: animation,
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      'https://avatars.githubusercontent.com/u/88382789?v=4',
                    ),
                  ),
                ),
              ),
              title: const Text(
                'Krishna Vishwakarma',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Web/App Developer',
              ),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      FluentIcons.code_24_filled,
                    ),
                    tooltip: 'Github',
                    onPressed: () {
                      launchUrl(
                        Uri.parse('https://github.com/Spyou'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FadeTransition(
            opacity: animation,
            child: ListTile(
              leading: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      'https://avatars.githubusercontent.com/u/104021711?v=4',
                    ),
                  ),
                ),
              ),
              title: const Text(
                'Ashutosh Pandey',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Web/App Developer',
              ),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      FluentIcons.code_24_filled,
                    ),
                    tooltip: 'Github',
                    onPressed: () {
                      launchUrl(
                        Uri.parse('https://github.com/Ashutosp'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
