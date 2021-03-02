import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_todo/screens/taskpage.dart';
import 'package:flutter_todo/widgets.dart';


class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
                    child: ListView(
                      children: [
                        TaskCardWidget(
                          title: "Get Started!",
                          desc: "Hello User! Welcome to FLUTTER_TODO app, this is a default task that you can edit or delete to start using the app",
                        ),
                        TaskCardWidget(),
                        TaskCardWidget(),
                        TaskCardWidget(),
                        TaskCardWidget(),
                      ],
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
                        builder: (context)=> Taskpage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF7349FE),
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
