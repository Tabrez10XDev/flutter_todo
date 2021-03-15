import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/model/task.dart';
import 'package:flutter_todo/model/todo.dart';
import 'package:flutter_todo/widgets.dart';

import '../databaseHelper.dart';

class Taskpage extends StatefulWidget {
  final Task task;
  Taskpage({@required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {

  int _taskId= 0;
  String _taskTitle = "";
  String _taskDescription = "";

  String _todoText = "";

  DatabaseHelper _dbHelper = DatabaseHelper();

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if(widget.task != null){
      _contentVisible = true;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top : 24.0, bottom: 6.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          } ,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                                image: AssetImage(
                                    'assets/images/back_arrow_icon.png'
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async{
                              if(value != ""){
                                if(widget.task == null){
                                  Task _newTask = Task(
                                      title: value
                                  );
                                  _taskId = await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                  print("New Task has been created: $_taskId");
                                }else{
                                  _dbHelper.updateTaskTitle(_taskId, value);
                                  print("Updating the existing task");
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()..text = _taskTitle,
                            decoration : InputDecoration(
                                hintText: "Enter Task Title",
                                border: InputBorder.none
                            ),
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color : Color(0xFF211551)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async{
                          _todoFocus.requestFocus();
                          if(value != ""){
                            if(_taskId != 0){
                              await _dbHelper.updateTaskDescription(_taskId, value);
                              _taskDescription = value;
                            }
                          }
                        },
                        controller: TextEditingController()..text = _taskDescription,
                        decoration: InputDecoration(
                            hintText: "Enter Description for the Task",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.0
                            )
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodo(_taskId),
                      builder: (context, snapshot){
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: () async{
                                  print("Todo before: ${snapshot.data[index]}");

                                  if(snapshot.data[index].isDone == 1){

                                    await _dbHelper.updateTodoState(snapshot.data[index].id, 0);
                                  }else{
                                    await _dbHelper.updateTodoState(snapshot.data[index].id, 1);
                                  }
                                  setState(() {});
                                  print("Todo Done: ${snapshot.data[index].isDone}");
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0 ? false : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 24.0),
                     child: Row(
                       children: [
                         Container(
                           margin: EdgeInsets.only(
                               right: 12.0
                           ),
                           width: 20.0,
                           height: 20.0,
                           decoration: BoxDecoration(
                               border: Border.all(
                                   color : Color(0xFF86829D)
                               ),
                               color: Colors.transparent,
                               borderRadius: BorderRadius.circular(6.0)
                           ),
                           child: Image(
                             image: AssetImage(
                                 'assets/images/check_icon.png'
                             ),
                           ),
                         ),
                         Expanded(
                           child: TextField(
                             focusNode: _todoFocus,
                             controller: TextEditingController()..text = _todoText,
                             onSubmitted: (value) async {
                               if(value != "")
                               {
                                 if(_taskId != 0){
                                   DatabaseHelper _dbHelper = DatabaseHelper();
                                   Todo _newTodo = Todo(
                                     title: value,
                                     isDone: 0,
                                     taskId: widget.task.id
                                   );
                                   await _dbHelper.insertTodo(_newTodo);
                                   print("New Todo has been created");
                                   setState(() {});
                                   _todoFocus.requestFocus();
                                 }
                               }
                             },
                             decoration: InputDecoration(
                                 hintText: "Enter Todo item...",
                                 border: InputBorder.none
                             ),
                           ),
                         )
                       ],
                     ),
                       ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async{
                      if(_taskId != 0){
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image(
                        image: AssetImage(
                            'assets/images/delete_icon.png'
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


