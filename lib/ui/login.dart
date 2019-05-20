import 'package:flutter/material.dart';
import 'todo.dart';
class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  TodoProvider _provider = TodoProvider();
  int index = 0;
  
  List<Todo> task;
  List<Todo> com;
  int cTask = 0;
  int comp = 0;
  void getTaskTodo() async{
    await _provider.open('todo.db');
    _provider.getall().then((taskTodo){
      setState(() {
        this.task = taskTodo;
        this.cTask = taskTodo.length;
      });
    });
    _provider.getto().then((compTodo){
      setState(() {
        this.com = compTodo;
        this.comp = compTodo.length;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    getTaskTodo();
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
            index == 0?
            Icons.add :
            Icons.delete),
            onPressed: () async {
              index == 0?
              Navigator.pushNamed(context, '/2')
              : await _provider.deleteAllCompTodo();
              setState(() {
                
              });
            },
          ),
        ],
      ),
      body: Center(
        child: index == 0?
        cTask > 0?
        ListView.builder(
          itemCount: cTask,
          itemBuilder: (context, int index){
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text(this.task[index].title),
                ),
                ListTile(
                  title: Text(this.task[index].user),
                ),
                ListTile(
                  title: Text(this.task[index].pass),
                )
                ,
              ],
            );
          },
        )
        :0
        :Text("No data found..")
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            
            title: new Text('Task'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.done_all),
            title: new Text('Completed'),
          ),
        ],
          onTap: (int i) {
              setState(() {
                index = i;
              });
            },
      ),
    );
  }

}