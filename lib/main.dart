import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:local_auth/local_auth.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:upasthiti/screens/ProfilePage.dart';
import 'AccessPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FingerPrint(),
      localizationsDelegates: [MonthYearPickerLocalizations.delegate],
    );
  }
}

class FingerPrint extends StatefulWidget {
  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric = false;
  List<BiometricType> _availableBiometric = [];
  String authorized = "Not authorized";

  Future<void> checkBiometric() async {
    bool permission = false;
    try {
      permission = await auth.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = permission;
    });
  }

  Future<void> checkAvailability() async {
    List<BiometricType> deviceBiometrics = [];
    try {
      deviceBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometric = deviceBiometrics;
    });
  }

  Future<void> authentication() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan Your Fingers for authentication",
          options: AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true, biometricOnly: true));
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      authorized = authenticated ? "Access Granted" : "Authorization falied";
      if (authorized == "Access Granted") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Access()));
      }
    });
  }

  @override
  void initState() {
    checkBiometric();
    checkAvailability();
    authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
