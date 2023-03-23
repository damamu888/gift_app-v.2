import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gift_app/views/home.dart';
import 'package:gift_app/widgets/auth_widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gift_app/localized_resolver.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'amplifyconfiguration.dart';
import 'constants/routes.dart';

void main() {
  runApp(const GiftApp());
}

class GiftApp extends StatefulWidget {
  const GiftApp({Key? key}) : super(key: key);

  @override
  State<GiftApp> createState() => _GiftAppState();
}

class _GiftAppState extends State<GiftApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      final authPlugin = AmplifyAuthCognito();
      await Amplify.addPlugin(authPlugin);
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      stringResolver: stringResolver,
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return SignInWidget(state: state);
          case AuthenticatorStep.signUp:
            return SignUpWidget(state: state);
          default:
            return null;
        }
      },
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('de'),
        ],
        builder: Authenticator.builder(),
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
        ),
        routes: {
          homeRoute: (context) => const HomeView(),
        },
        home: const HomeView(),
      ),
    );
  }
}
