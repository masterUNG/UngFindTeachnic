import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungfindteachnic/models/user_model.dart';
import 'package:ungfindteachnic/utility/dialog.dart';
import 'package:ungfindteachnic/utility/my_style.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  double screenWidth, screenHeight;
  String typeUser, name, user, password;

  Container buildDisplayName() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.fingerprint,
            color: MyStyle().darkColor,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Display Name :',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().lightColor)),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'User :',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().lightColor)),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock_outline,
            color: MyStyle().darkColor,
          ),
          labelStyle: MyStyle().darkStyle(),
          labelText: 'Password :',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: MyStyle().darkColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().lightColor)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
        backgroundColor: MyStyle().primaryColor,
      ),
      body: Stack(
        children: [
          MyStyle().buildBackground(screenWidth, screenHeight),
          buildContent(),
        ],
      ),
    );
  }

  Center buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildDisplayName(),
            buildTitle(),
            buildTypeUser(),
            buildTypeTechnicial(),
            buildUser(),
            buildPassword(),
            buildCreateAccount(),
          ],
        ),
      ),
    );
  }

  Container buildCreateAccount() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: screenWidth * 0.6,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: MyStyle().darkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            if ((name?.isEmpty ?? true) ||
                (user?.isEmpty ?? true) ||
                (password?.isEmpty ?? true)) {
              // print('Have Space');
              normalDialog(context, 'Have Space ?', 'Please Fill Every Blank');
            } else if (typeUser == null) {
              normalDialog(context, 'No TypeUser ?',
                  'Please Choose Type User by Click User or Technical');
            } else {
              createAccountAndInsertInformation();
            }
          },
          icon: Icon(Icons.cloud_upload),
          label: Text('Create Account')),
    );
  }

  Future<Null> createAccountAndInsertInformation() async {
    await Firebase.initializeApp().then((value) async {
      // print('## Firebase Initialize Success user ==> $user, password ==> $password ##');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: password)
          .then((value) async {
        print('Create Account Success');
        await value.user.updateProfile(displayName: name).then((value2) async {
          String uid = value.user.uid;
          print('Update Profile Success and uid = $uid');

          UserModel model =
              UserModel(email: user, name: name, typeuser: typeUser);
          Map<String, dynamic> data = model.toMap();

          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .set(data)
              .then((value) {
            print('Insert Value To Firestore Success');
            switch (typeUser) {
              case 'user':
                Navigator.pushNamedAndRemoveUntil(
                    context, '/myServiceUser', (route) => false);
                break;
              case 'technical':
                Navigator.pushNamedAndRemoveUntil(
                    context, '/myServiceTechnicial', (route) => false);
                break;
              default:
            }
          });
        });
      }).catchError((onError) =>
              normalDialog(context, onError.code, onError.message));
    });
  }

  Container buildTypeUser() {
    return Container(
      width: screenWidth * 0.6,
      child: RadioListTile(
        value: 'user',
        groupValue: typeUser,
        onChanged: (value) {
          setState(() {
            typeUser = value;
          });
        },
        title: Text(
          'User',
          style: MyStyle().darkStyle(),
        ),
      ),
    );
  }

  Container buildTypeTechnicial() {
    return Container(
      width: screenWidth * 0.6,
      child: RadioListTile(
        value: 'technical',
        groupValue: typeUser,
        onChanged: (value) {
          setState(() {
            typeUser = value;
          });
        },
        title: Text(
          'Technical',
          style: MyStyle().darkStyle(),
        ),
      ),
    );
  }

  Container buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: Text(
        'Type User:',
        style: MyStyle().darkStyle(),
      ),
    );
  }
}
