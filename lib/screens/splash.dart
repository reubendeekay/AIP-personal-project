import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sportal/providers/auth_provider.dart';
import 'package:sportal/screens/lobby.dart';
import 'package:sportal/screens/login.dart';
import 'package:sportal/util/color_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUser(initial: true);

      Get.off(() => const Lobby());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: const [
          Expanded(child: RippleLogo()),
          Text(
            'The Complete solution',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class RippleLogo extends StatelessWidget {
  const RippleLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Lottie.asset(
            'assets/ripple.json',
            height: 400,
          ),
        ),
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 30,
          ),
        ),
      ],
    );
  }
}
