import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:upasthiti/model/User.dart';

class Today extends StatefulWidget {
  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  String checkIn = "- -/- -";
  String checkOut = "- -/- -";
  String location = " ";
  ConfettiController confetti = ConfettiController();
  @override
  void initState() {
    super.initState();
    getRecord();
  }

  void getLocation() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(User.lat, User.long);
    print(User.lat);

    setState(() {
      location =
          "${placemark[0].street},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
    });
  }

  void getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Scholar_${User.studentId}")
          .where("scholarNo", isEqualTo: User.studentId)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Scholar_${User.studentId}")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat("dd MMMM yyyy").format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = "- -/- -";
        checkOut = "- -/- -";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confetti,
                shouldLoop: false,
                blastDirection: -1.57,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.00,
                numberOfParticles: 500,
                gravity: 0.3,
              ),
            ),
            Container(
              padding:
                  EdgeInsets.fromLTRB(width / 14, width / 20, 0, width / 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome,',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF0165ff),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Comfortaa")),
                  Text('Scholar No ' + User.studentId,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Comfortaa")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: width / 14),
              child: DefaultTextStyle(
                style: TextStyle(
                    fontSize: 20.00,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText("Today's Status",
                        speed: Duration(milliseconds: 100)),
                  ],
                  isRepeatingAnimation: true,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Info(
                    width: width,
                    height: height,
                    text1: 'Check In',
                    text2: checkIn,
                  ),
                  Info(
                    width: width,
                    height: height,
                    text1: 'Check Out',
                    text2: checkOut,
                  )
                ],
              ),
            ),
            StreamBuilder(
                stream: Stream.periodic(Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    padding:
                        EdgeInsets.only(left: width / 14, top: height / 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat("dd MMMM yyyy").format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.00,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat("hh:mm:ss a").format(DateTime.now()),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15.00),
                        ),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: height / 34,
            ),
            checkOut == "- -/- -"
                ? Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Builder(builder: (context) {
                      final GlobalKey<SlideActionState> key = GlobalKey();
                      return SlideAction(
                        outerColor: Color(0xFF0165ff),
                        key: key,
                        onSubmit: () async {
                          if (User.lat != 0 && User.long != 0) {
                            getLocation();
                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection("Scholar_${User.studentId}")
                                .where("scholarNo", isEqualTo: User.studentId)
                                .get();

                            DocumentSnapshot snap2 = await FirebaseFirestore
                                .instance
                                .collection("Scholar_${User.studentId}")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat("dd MMMM yyyy")
                                    .format(DateTime.now()))
                                .get();

                            try {
                              String checkIn = snap2['checkIn'];
                              setState(() {
                                checkOut = DateFormat("hh:mm a")
                                    .format(DateTime.now());
                                confetti.play();
                              });
                              await FirebaseFirestore.instance
                                  .collection("Scholar_${User.studentId}")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat("dd MMMM yyyy")
                                      .format(DateTime.now()))
                                  .update({
                                'checkIn': checkIn,
                                'checkOut': DateFormat("hh:mm a")
                                    .format(DateTime.now()),
                                'date': Timestamp.now(),
                                'checkInlocation': location
                              });
                            } catch (e) {
                              setState(() {
                                checkIn = DateFormat("hh:mm a")
                                    .format(DateTime.now());
                              });
                              await FirebaseFirestore.instance
                                  .collection("Scholar_${User.studentId}")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat("dd MMMM yyyy")
                                      .format(DateTime.now()))
                                  .set({
                                'checkIn': DateFormat("hh:mm a")
                                    .format(DateTime.now()),
                                'checkOut': "- -/- -",
                                'date': Timestamp.now(),
                                'checkOutlocation': location
                              });
                            }
                            key.currentState!.reset();
                          } else {
                            Timer(Duration(seconds: 3), () async {
                              getLocation();
                              QuerySnapshot snap = await FirebaseFirestore
                                  .instance
                                  .collection("Scholar_${User.studentId}")
                                  .where("scholarNo", isEqualTo: User.studentId)
                                  .get();

                              DocumentSnapshot snap2 = await FirebaseFirestore
                                  .instance
                                  .collection("Scholar_${User.studentId}")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat("dd MMMM yyyy")
                                      .format(DateTime.now()))
                                  .get();

                              try {
                                String checkIn = snap2['checkIn'];
                                setState(() {
                                  checkOut = DateFormat("hh:mm a")
                                      .format(DateTime.now());
                                  confetti.play();
                                });
                                await FirebaseFirestore.instance
                                    .collection("Scholar_${User.studentId}")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat("dd MMMM yyyy")
                                        .format(DateTime.now()))
                                    .update({
                                  'checkIn': checkIn,
                                  'checkOut': DateFormat("hh:mm a")
                                      .format(DateTime.now()),
                                  'date': Timestamp.now(),
                                  'checkInlocation': location
                                });
                              } catch (e) {
                                setState(() {
                                  checkIn = DateFormat("hh:mm a")
                                      .format(DateTime.now());
                                });
                                await FirebaseFirestore.instance
                                    .collection("Scholar_${User.studentId}")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat("dd MMMM yyyy")
                                        .format(DateTime.now()))
                                    .set({
                                  'checkIn': DateFormat("hh:mm a")
                                      .format(DateTime.now()),
                                  'checkOut': "- -/- -",
                                  'date': Timestamp.now(),
                                  'checkOutlocation': location
                                });
                              }
                              key.currentState!.reset();
                            });
                          }
                        },
                        text: checkIn == "- -/- -"
                            ? "Slide to check In "
                            : "Slide to check Out",
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.00,
                        ),
                      );
                    }),
                  )
                : Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 32, bottom: 32),
                      child: Center(
                          child: Text(
                        'You have checked out successfully!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
            location != " "
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF0165ff),
                            size: 40,
                          ),
                          Expanded(
                            child: Text(
                              'location : $location',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  Info(
      {required this.width,
      required this.height,
      required this.text1,
      required this.text2});

  final double width;
  final double height;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width / 2.2,
      height: height / 4.5,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xFF0165ff),
        borderRadius: BorderRadius.circular(20.00),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text1,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text2,
              style: TextStyle(
                  color: Colors.white, fontSize: 30, fontFamily: "Bebas_Neue"),
            )
          ],
        ),
      ),
    );
  }
}
