import 'package:flutter/material.dart';
import 'package:ungfindteachnic/widget/my_signout.dart';

class MyServiceUser extends StatefulWidget {
  @override
  _MyServiceUserState createState() => _MyServiceUserState();
}

class _MyServiceUserState extends State<MyServiceUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome User'),
      ),drawer: Drawer(child: MySignOut(),),
    );
  }
}
