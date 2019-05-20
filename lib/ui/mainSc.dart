import 'package:flutter/material.dart';
import 'todo.dart';
class MainSc extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<MainSc> {
  final alter1 =GlobalKey<FormState>();
  
  TodoProvider provider = TodoProvider();
  final input1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Form(
        key: alter1,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Subject",
              ),
              controller: input1,
              validator: (subject){
                if (subject.isEmpty){
                  return "Please fill subject";
                }
              },
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: () async{
                if (alter1.currentState.validate()) {
                  await provider.open('todo.db');
                  await provider.insert(Todo(title : input1.text));
                  print(await provider.db.rawQuery('select * from todo'));
                  Navigator.pop(context);
                }
              }
            ),
          ],
        ),
      ),
    );
  }
  
}