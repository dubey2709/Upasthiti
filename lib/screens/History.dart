import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:upasthiti/model/User.dart';

class AttendanceHistory extends StatefulWidget {
  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  String _month = DateFormat("MMMM yyyy").format(DateTime.now());
  int length = 0;

  Future count() async {
    QuerySnapshot qsnap = await FirebaseFirestore.instance
        .collection("Scholar_${User.studentId}")
        .get();
    setState(() {
      length = qsnap.docs.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 40, 15, 15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text('My Attendance',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Comfortaa")),
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: height / 34),
                  alignment: Alignment.centerLeft,
                  child: Text(_month,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Comfortaa")),
                ),
                Container(
                  margin: EdgeInsets.only(top: height / 34),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      final month = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2099),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData().copyWith(
                                  colorScheme: ColorScheme.light(
                                      primary: Color(0xFF0165ff),
                                      secondary: Color(0xFF0165ff),
                                      onSecondary: Colors.white),
                                  textTheme: TextTheme(
                                    headline4:
                                        TextStyle(fontFamily: "Bebas_Neue"),
                                    overline:
                                        TextStyle(fontFamily: "Bebas_Neue"),
                                    button: TextStyle(
                                        fontFamily: "Bebas_Neue", fontSize: 20),
                                  )),
                              child: child!,
                            );
                          });

                      if (month != null) {
                        setState(() {
                          _month = DateFormat("MMMM yyyy").format(month);
                        });
                      }
                    },
                    child: Text('Month',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Comfortaa")),
                  ),
                ),
              ],
            ),
            Container(
              height: 0.8 * height,
              child: length != 0
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Scholar_${User.studentId}")
                          .doc(User.id)
                          .collection("Record")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return DateFormat('MMMM yyyy').format(snapshot
                                            .data!.docs[index]['date']
                                            .toDate()) ==
                                        _month
                                    ? Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width / 1.1,
                                              height: height / 5,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.00),
                                                border: Border.all(
                                                    color: Color(0xFF0165ff),
                                                    width: 2),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: width / 3,
                                                      height: height / 5,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        color:
                                                            Color(0xFF0165ff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.00),
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          DateFormat('EE\n dd ')
                                                              .format(snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                      ['date']
                                                                  .toDate()),
                                                          style: TextStyle(
                                                              fontSize: 30.00,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Bebas_Neue"),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: width / 25),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          " Check In",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width / 26,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height / 70),
                                                        Text(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['checkIn'],
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width / 20,
                                                              fontFamily:
                                                                  "Bebas_Neue"),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: width / 25,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          " Check Out",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width / 26,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                height / 70),
                                                        Text(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['checkOut'],
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width / 20,
                                                              fontFamily:
                                                                  "Bebas_Neue"),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox();
                              });
                        } else {
                          return Center(
                            child: SizedBox(),
                          );
                        }
                      },
                    )
                  : Center(
                      child: Container(
                        child: Text(
                          'No events attended till now :(',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
