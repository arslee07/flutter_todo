import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TODO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  List<TaskState> tasks = <TaskState>[];

  void _submit() {
    setState(() {
      if (myController.text.trim() != '') tasks.add(TaskState(myController.text.trim()));
      myController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SafeArea(
            minimum: EdgeInsets.all(12),
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(hintText: "Type your task here..."),
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text('Submit'),
                  ),
                  flex: 0,
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.separated(
            itemCount: tasks.length,
            itemBuilder: (BuildContext ctx, int index) {
              final task = tasks[index];

              return InkWell(
                onTap: () {
                  setState(() {
                    task.done = !task.done;
                  });
                },
                child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Task "${task.text}" has successfully been deleted'),
                        duration: Duration(seconds: 1),
                      ));
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                    ),
                    child: Container(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(task.text,
                                style: task.done
                                    ? TextStyle(decoration: TextDecoration.lineThrough, fontSize: 24)
                                    : TextStyle(fontSize: 24)),
                          ),
                        ))),
              );
            },
            separatorBuilder: (_, __) => Divider(
              height: 1,
            ),
          ))
        ],
      ),
    );
  }
}

class TaskState {
  bool done = false;
  String text;

  TaskState(this.text);
}
