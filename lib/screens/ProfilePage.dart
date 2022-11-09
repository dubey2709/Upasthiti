import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upasthiti/model/User.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color myColor = Color(0xFF0165ff);
  TextEditingController firstName = TextEditingController();
  TextEditingController secondName = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController semester = TextEditingController();

  void ProfilePic() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 90);

    Reference ref = await FirebaseStorage.instance
        .ref()
        .child("${User.studentId.toLowerCase()}_profile.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        User.profile_link = value;
      });

      await FirebaseFirestore.instance
          .collection('Scholar_${User.studentId}')
          .doc(User.id)
          .update({'profilePic': value});
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 0.98 * width,
                    height: height / 5.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('GIF/gif2.gif'), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: height / 15,
                    child: CircleAvatar(
                      radius: height / 9.5,
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          ProfilePic();
                        },
                        child: CircleAvatar(
                          radius: height / 10,
                          child: User.profile_link == " "
                              ? Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 80,
                                )
                              : null,
                          backgroundImage: User.profile_link != null
                              ? NetworkImage(User.profile_link)
                              : null,
                          backgroundColor: myColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 12.5),
              Container(
                padding: EdgeInsets.only(top: height / 34),
                child: Text(
                  User.studentId,
                  style: TextStyle(fontSize: 30, fontFamily: "Bebas_Neue"),
                ),
              ),
              Column(
                  children: User.canEdit
                      ? [
                          TextsField("First Name", "Enter your First Name",
                              firstName, true),
                          TextsField("Last Name", "Enter your Last Name",
                              secondName, true),
                          TextsField("Department", "Enter your Department Name",
                              department, true),
                          TextsField(
                              "Semester",
                              "Enter your current semester No.",
                              semester,
                              true),
                        ]
                      : [
                          TextsField(
                              "First Name", User.firstName, firstName, false),
                          TextsField(
                              "Last Name", User.lastName, secondName, false),
                          TextsField(
                              "Department", User.dept, department, false),
                          TextsField("Semester", User.currentSemester, semester,
                              false),
                        ]),
              User.canEdit
                  ? Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: SizedBox(
                        height: height / 13.5,
                        width: width / 3,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(myColor),
                            ),
                            onPressed: () async {
                              if (User.canEdit) {
                                String firstname = firstName.text;
                                String secondname = secondName.text;
                                String dept = department.text;
                                String sem = semester.text;
                                if (firstname.isEmpty) {
                                  showSnackBar('Please Enter your first name!');
                                } else if (secondname.isEmpty) {
                                  showSnackBar("Please Enter your last name!");
                                } else if (dept.isEmpty) {
                                  showSnackBar(
                                      "Please Enter your department name!");
                                } else if (sem.isEmpty) {
                                  showSnackBar(
                                      "Please Enter your current semester number!");
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('Scholar_${User.studentId}')
                                      .doc(User.id)
                                      .update({
                                    'firstname': firstname,
                                    'lastname': secondname,
                                    'department': dept,
                                    'semester': sem,
                                    'canEdit': false
                                  }).then((value) {
                                    setState(() {
                                      User.canEdit = false;
                                      User.firstName = firstname;
                                      User.lastName = secondname;
                                      User.dept = dept;
                                      User.currentSemester = sem;
                                    });
                                  });
                                }
                              } else {
                                showSnackBar('Why are you doing this dude');
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(fontSize: 15),
                            )),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        )));
  }
}

class TextsField extends StatelessWidget {
  TextsField(this.fieldname, this.hint, this.controller, this.editingEnabled);
  final String fieldname;
  final String hint;
  final TextEditingController controller;
  final bool editingEnabled;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    return Container(
      padding: EdgeInsets.only(
          right: width / 14, left: width / 14, top: height / 68),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldname,
            style: TextStyle(color: Colors.grey[900], fontSize: 15),
          ),
          SizedBox(height: height / 136),
          SizedBox(
            height: height / 12.5,
            width: width / 1.12,
            child: TextField(
              readOnly: !editingEnabled,
              controller: controller,
              onChanged: (value) {},
              cursorColor: Color(0xFF0165ff),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: hint,
                  hintStyle: editingEnabled
                      ? TextStyle()
                      : TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                  enabledBorder: editingEnabled
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Color(0xFF0165ff)))
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFF0165ff))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFF0165ff)))),
            ),
          ),
        ],
      ),
    );
  }
}
