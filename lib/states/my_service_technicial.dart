import 'package:flutter/material.dart';
import 'package:ungfindteachnic/widget/my_signout.dart';

class MyServiceTechnicial extends StatefulWidget {
  @override
  _MyServiceTechnicialState createState() => _MyServiceTechnicialState();
}

class _MyServiceTechnicialState extends State<MyServiceTechnicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Technicial'),
      ),drawer: Drawer(child: MySignOut(),)
    );
  }
}
