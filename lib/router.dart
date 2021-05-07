import 'package:flutter/material.dart';
import 'package:ungfindteachnic/states/authen.dart';
import 'package:ungfindteachnic/states/create_account.dart';
import 'package:ungfindteachnic/states/my_service_technicial.dart';
import 'package:ungfindteachnic/states/my_service_user.dart';

final Map<String, WidgetBuilder> map = {
  '/authen':(BuildContext context)=>Authen(),
  '/createAccount':(BuildContext context)=> CreateAccount(),
  '/myServiceUser':(BuildContext context)=> MyServiceUser(),
  '/myServiceTechnicial':(BuildContext context)=> MyServiceTechnicial(),
};
