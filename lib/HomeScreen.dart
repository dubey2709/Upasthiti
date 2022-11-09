import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:upasthiti/Location/Location.dart';
import 'package:upasthiti/model/User.dart';
import 'screens/ProfilePage.dart';
import 'screens/Today.dart';
import 'screens/History.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [Today(), AttendanceHistory(), Profile()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.today),
        title: ("Today"),
        activeColorPrimary: Color(0xFF0165ff),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_month_outlined),
        title: ("Calendar"),
        activeColorPrimary: Color(0xFF0165ff),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Color(0xFF0165ff),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    fetchingLocation();
    getId().then((value) {
      getcredentials();
      profile();
    });
  }

  void getcredentials() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Scholar_${User.studentId}')
        .doc(User.id)
        .get();
    setState(() {
      User.canEdit = doc['canEdit'];
      User.firstName = doc['firstname'];
      User.lastName = doc['lastname'];
      User.dept = doc['department'];
      User.currentSemester = doc['semester'];
    });
  }

  void profile() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Scholar_${User.studentId}')
        .doc(User.id)
        .get();
    setState(() {
      User.profile_link = doc['profilePic'];
    });
  }

  void fetchingLocation() async {
    LocationService().start();
    LocationService().latitude().then((value) {
      setState(() {
        User.lat = value!;
      });

      LocationService().longitude().then((value) {
        setState(() {
          User.long = value!;
        });
      });
    });
  }

  Future<void> getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Scholar_${User.studentId}")
        .where("scholarNo", isEqualTo: User.studentId)
        .get();

    setState(() {
      User.id = snap.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
