import 'package:sqflite/sqflite.dart';


final String tableTodo = "todo";
final String columnId = "_id";
final String columnTitle = "title";
final String columnDone = "done";
final String columnuser = "user";
final String columnpass = "password";

class Todo {
  int id;
  String title;
  String user;
  String pass;
  bool done;
  Todo.fromMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.title = map[columnTitle];
    this.done = map[columnDone] == 1;
    this.user = map[columnuser];
    this.pass = map[columnpass];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0,
      columnuser: user,
      columnpass:pass,
    };
    if(id != null) {
      map[columnId] = id;
    }
    return map;
  }
  Todo(
    {
    this.id, 
    this.title, 
    this.done,
    this.user = 'User',
    this.pass = 'pass'
    }
    );
}

class TodoProvider {
  Database db;
  
  Future open(String path) async {
    db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async{
      await db.execute(
        '''create table $tableTodo (
          $columnId integer primary key autoincrement,
          $columnTitle text not null,
          $columnDone integer not null,
          $columnuser text not null,
          $columnpass integer not null)
        '''
      );
    });
  }
  Future<Todo> insert(Todo todo) async{
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async{
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
        if (maps.length > 0) {
          return new Todo.fromMap(maps.first);
        }
        return null;
  }

  Future<int> delete(int id) async{
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Todo todo) async{
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }
  //test
  Future<List<Todo>> getto() async{
    var todo =await db.query(tableTodo, where: "$columnDone = 1");
    return todo.map((string) => Todo.fromMap(string)).toList();
  }
  //test
  Future deleteAllCompTodo() async{
    await db.delete(tableTodo, where: "$columnDone = 1");
  }
  //test
  Future<List<Todo>> getall() async{
    var todo = await db.query(tableTodo, where: "$columnDone = 0");
    return todo.map((string) =>Todo.fromMap(string)).toList();
  }

  
  Future close() => db.close();
}