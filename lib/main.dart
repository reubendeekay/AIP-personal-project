import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:sportal/providers/auth_provider.dart';
import 'package:sportal/providers/visitors_provider.dart';
import 'package:sportal/screens/login.dart';
import 'package:sportal/screens/splash.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/util/material_color_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      systemNavigationBarColor: primaryColor,
    ),
  );
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VisitorProvider()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        designSize: const Size(375, 812),
        builder: (context, _) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sportal',
          theme: ThemeData(
            primaryColor: primaryColor,
            primarySwatch: createMaterialColor(primaryColor),
          ),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Login();
                }

                return const SplashScreen();
              }),
        ),
      ),
    );
  }
}
