import 'package:event_manager/models/UserModel.dart';
import 'package:event_manager/screens/event/events.dart';
import 'package:event_manager/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cres Days',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff92a95f)),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoggedIn = false;
  FlutterSecureStorage _storage = FlutterSecureStorage();
  String role = '';
  User user = User(name: '', role: '');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUserLoggedIn();
  }

  void isUserLoggedIn() async {
    bool isLogged = await _storage.read(key: 'sessionId') != null;

    final x = await _storage.read(key: 'role');
    final name = await _storage.read(key: 'name');
    setState(() {
      user = User(name: name ?? '', role: x ?? '');
      role = x ?? '';
      isLoggedIn = isLogged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? EventScreen(
            role: role,
            user: user,
          )
        : loginScreen();
  }
}
