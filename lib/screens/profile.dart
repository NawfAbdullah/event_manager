import 'package:event_manager/components/cards/InvitationCard.dart';
import 'package:event_manager/components/cards/RequestCard.dart';
import 'package:event_manager/components/buttons/SubmitButton.dart';
import 'package:event_manager/components/cards/TheCard.dart';
import 'package:event_manager/constants/constants.dart';
import 'package:event_manager/models/InvitationModel.dart';
import 'package:event_manager/models/RequestModel.dart';
import 'package:event_manager/models/UserModel.dart';
import 'package:event_manager/screens/changepassword.dart';
import 'package:event_manager/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  Future<User> user = getUser();
  Future<List<InvitationModel>> request = getAllInvitation();
  @override
  Widget build(BuildContext context) {
    FlutterSecureStorage storage = FlutterSecureStorage();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    return TheCard('Hi,${snapshot.data?.name}',
                        icon: Icons.edit, subText: snapshot.data?.role ?? '');
                  } else {
                    return CircularProgressIndicator();
                  }
              }
            }),
        Container(
          height: MediaQuery.of(context).size.height * 0.55,
          child: FutureBuilder(
            future: request,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return throw Exception(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    return (snapshot.data!.isNotEmpty)
                        ? ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data![index].status == "waiting") {
                                return InvitationCard(
                                    invitationModel: snapshot.data![index]);
                              }
                            },
                          )
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/empty-inbox.png',
                                width: 200,
                              ),
                              const Text(
                                'No Invitations',
                                style: kSubText,
                              ),
                            ],
                          ));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
              }
            },
          ),
        ),
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
              child: const Text(
                'logout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.redAccent,
                  fontSize: 16,
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
//<a href="https://www.flaticon.com/free-icons/empty" title="empty icons">Empty icons created by Freepik - Flaticon</a>
//<a href="https://www.flaticon.com/free-icons/empty-inbox" title="empty inbox icons">Empty inbox icons created by andinur - Flaticon</a>