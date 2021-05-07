import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ungfindteachnic/models/user_model.dart';
import 'package:ungfindteachnic/utility/my_style.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  double screenWidth, screenHeight;
  bool redEye = true;
  String typeUser = 'user', name, email, uid;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: buildCreateAccount(),
      body: SafeArea(
        child: Stack(
          children: [
            MyStyle().buildBackground(screenWidth, screenHeight),
            Positioned(
              top: 40,
              left: 16,
              child: buildLogo(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.25,
                    ),
                    buildUser(),
                    buildPassword(),
                    buildSignInEmail(),
                    buildSignInGoogle(),
                    buildSignInFacebook(),
                    buildSignInApple(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 50,
        ),
        Text(
          'Non Account ?',
          style: MyStyle().whiteStyle(),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/createAccount'),
          child: Text(
            'Create Account',
            style: MyStyle().activeStyle(),
          ),
        ),
      ],
    );
  }

  Container buildSignInEmail() => Container(
        margin: EdgeInsets.only(top: 8),
        child: SignInButton(
          Buttons.Email,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

  Container buildSignInGoogle() => Container(
        margin: EdgeInsets.only(top: 8),
        child: SignInButton(
          Buttons.GoogleDark,
          onPressed: () => processSingInWithGoogle(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

  Future<Null> processSingInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    await Firebase.initializeApp().then((value) async {
      await _googleSignIn.signIn().then((value) async {
        name = value.displayName;
        email = value.email;
        await value.authentication.then((value2) async {
          AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: value2.idToken,
            accessToken: value2.accessToken,
          );
          await FirebaseAuth.instance
              .signInWithCredential(authCredential)
              .then((value3) async {
            uid = value3.user.uid;
            print(
                'Login With gmail Success value With name = $name, email = $email, uid = $uid');

            await FirebaseFirestore.instance
                .collection('user')
                .doc(uid)
                .snapshots()
                .listen((event) {
              print('event ==> ${event.data()}');
              if (event.data() == null) {
                // Call TypeUser
                callTypeUserDialog();
              } else {
                // Route to Service by TypeUser
                print('Route to Service ==>> ${event.id}');

              }
            });
          });
        });
      });
    });
  }

  

  Future<Null> insertValueToCloudFirestore() async {
    UserModel model = UserModel(name: name, email: email, typeuser: typeUser);
    Map<String, dynamic> data = model.toMap();

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set(data)
          .then((value) {
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
  }

  Future<Null> callTypeUserDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: ListTile(
                leading: MyStyle().showLogo(),
                title: Text('Type User ?'),
                subtitle: Text('Please Choose Type User'),
              ),
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  width: 200,
                  child: Column(
                    children: [
                      RadioListTile(
                        value: 'user',
                        groupValue: typeUser,
                        onChanged: (value) {
                          setState(() {
                            typeUser = value;
                          });
                        },
                        title: Text('User'),
                      ),
                      RadioListTile(
                        value: 'technical',
                        groupValue: typeUser,
                        onChanged: (value) {
                          setState(() {
                            typeUser = value;
                          });
                        },
                        title: Text('Technical'),
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      print(
                          'Call Type User, name = $name, email = $email, typeUser = $typeUser, uid = $uid');
                      insertValueToCloudFirestore();
                    },
                    child: Text('OK')),
              ],
            );
          },
        );
      },
    );
  }

  Container buildSignInFacebook() => Container(
        margin: EdgeInsets.only(top: 8),
        child: SignInButton(
          Buttons.FacebookNew,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

  Container buildSignInApple() => Container(
        margin: EdgeInsets.only(top: 8),
        child: SignInButton(
          Buttons.AppleDark,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screenWidth * 0.6,
      child: TextField(
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
        obscureText: redEye,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(
                redEye
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye_sharp,
                color: MyStyle().darkColor,
              ),
              onPressed: () {
                setState(() {
                  redEye = !redEye;
                });
              }),
          prefixIcon: Icon(
            Icons.lock_outlined,
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

  Container buildLogo() {
    return Container(
      width: screenWidth * 0.35,
      child: MyStyle().showLogo(),
    );
  }
}
