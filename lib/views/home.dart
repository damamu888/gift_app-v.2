import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String nickname;

  Future<void> getNickname() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final element in attributes) {
        if (element.userAttributeKey == CognitoUserAttributeKey.nickname) {
          nickname = element.value;
        }
      }
    } on AuthException catch (e) {
      safePrint(e);
    }
  }

  Future<void> signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              leading: Center(
                child: Text(nickname),
              ),
              title: const Text('Home'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: signOutCurrentUser,
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: getNickname(),
    );
  }
}
