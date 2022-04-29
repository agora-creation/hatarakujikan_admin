import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hatarakujikan_admin/helpers/style.dart';
import 'package:hatarakujikan_admin/providers/admin.dart';
import 'package:hatarakujikan_admin/providers/group.dart';
import 'package:hatarakujikan_admin/screens/admin.dart';
import 'package:hatarakujikan_admin/screens/group.dart';
import 'package:hatarakujikan_admin/screens/login.dart';
import 'package:hatarakujikan_admin/screens/splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  if (FirebaseAuth.instance.currentUser == null) {
    await Future.any([
      FirebaseAuth.instance.userChanges().firstWhere((e) => e != null),
      Future.delayed(Duration(milliseconds: 3000)),
    ]);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AdminProvider.initialize()),
        ChangeNotifierProvider.value(value: GroupProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('ja'),
        ],
        locale: const Locale('ja'),
        title: 'はたらくじかんforADMIN',
        theme: theme(),
        home: SplashController(),
        routes: {
          AdminScreen.id: (context) => AdminScreen(),
          GroupScreen.id: (context) => GroupScreen(),
        },
      ),
    );
  }
}

class SplashController extends StatefulWidget {
  @override
  State<SplashController> createState() => _SplashControllerState();
}

class _SplashControllerState extends State<SplashController> {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    switch (adminProvider.status) {
      case Status.Uninitialized:
        return SplashScreen();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginScreen();
      case Status.Authenticated:
        return GroupScreen();
      default:
        return LoginScreen();
    }
  }
}
