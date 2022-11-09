import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  late String scholarNo;
  late String password;
  late SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0165ff),
          title: Text('Upasthiti'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(width / 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Image(
                  image: AssetImage('GIF/gif1.gif'),
                  height: height / 4.5,
                  width: 0.75 * width,
                ),
                SizedBox(height: height / 17),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: width / 14),
                      child: Text(
                        'Student Login',
                        style: TextStyle(
                          fontSize: 20.00,
                          color: Color(0xFF0165ff),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Login Text Field
                Container(
                  padding: EdgeInsets.all(width / 20),
                  child: TextField(
                    onChanged: (value) {
                      scholarNo = value;
                    },
                    cursorColor: Color(0xFF0165ff),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon:
                          Icon(Icons.perm_identity, color: Color(0xFF0165ff)),
                      hintText: 'Enter your Scholar Number',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Color(0xFF0165ff))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFF0165ff))),
                    ),
                  ),
                ),

                // Password Text Field
                Container(
                  padding: EdgeInsets.fromLTRB(
                      width / 20, 0, width / 20, width / 20),
                  child: TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    cursorColor: Color(0xFF0165ff),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon:
                          Icon(Icons.password, color: Color(0xFF0165ff)),
                      hintText: 'Enter your Password',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Color(0xFF0165ff))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFF0165ff))),
                    ),
                  ),
                ),

                // Login Button
                Container(
                  padding: EdgeInsets.fromLTRB(
                      width / 20, height / 14, width / 20, width / 20),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      elevation: 10.00,
                      minWidth: width / 1.2,
                      height: height / 11.5,
                      color: Color(0xFF0165ff),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (scholarNo.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Please fill your Scholar Number")));
                        } else if (password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill your Password")));
                        } else {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Scholar_${scholarNo}")
                              .where("scholarNo", isEqualTo: scholarNo)
                              .get();
                          try {
                            if (password == snap.docs[0]['password']) {
                              sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences
                                  .setString("StudentId", scholarNo)
                                  .then((_) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Invalid Password")));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error !")));
                          }
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20.00),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
