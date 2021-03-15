import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_todo/databaseHelper.dart';
import 'package:flutter_todo/screens/taskpage.dart';
import 'package:flutter_todo/widgets.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 32.0,
                      top: 32.0
                    ),
                    child: Image(
                      image: AssetImage(
                        'assets/images/logo.png'
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot){
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: (){
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) => Taskpage(
                                         task: snapshot.data[index],
                                       )));
                                },
                                child: TaskCardWidget(
                                  title: snapshot.data[index].title,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=> Taskpage(task: null,),
                      ),
                    ).then((value){
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7349FE), Color(0xFF643DFB)],
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0,1.0)
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image(
                      image: AssetImage(
                        'assets/images/add_icon.png'
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

// TaskCardWidget(
// title: "Get Started!",
// desc: "Hello User! Welcome to FLUTTER_TODO app, this is a default task that you can edit or delete to start using the app",
// ),