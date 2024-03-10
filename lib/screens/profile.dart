import 'package:event_manager/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterSecureStorage storage = FlutterSecureStorage();
    return Column(
      children: [
        Text("Name:Zameel"),
        GestureDetector(
          onTap: () async {
            await storage.delete(key: 'sessionId');
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => loginScreen()));
          },
          child: Text(
            'logout',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
        )
      ],
    );
  }
}
