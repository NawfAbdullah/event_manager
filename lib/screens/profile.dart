import 'package:event_manager/components/SubmitButton.dart';
import 'package:event_manager/models/UserModel.dart';
import 'package:event_manager/screens/changepassword.dart';
import 'package:event_manager/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  Future<User> user = getUser();
  @override
  Widget build(BuildContext context) {
    FlutterSecureStorage storage = FlutterSecureStorage();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'CRES DAYS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Name:${snapshot.data?.name}'),
                        Text('Role: ${snapshot.data?.role}')
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
              }
            }),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SubmitButton(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangePassword()));
                },
                innerText: 'Change Password'),
            GestureDetector(
              onTap: () async {
                await storage.delete(key: 'sessionId');
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => loginScreen()));
              },
              child: Text(
                'logout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
