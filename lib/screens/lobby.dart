import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sportal/providers/auth_provider.dart';
import 'package:sportal/screens/activity_log.dart';
import 'package:sportal/screens/enter.dart';
import 'package:sportal/screens/exit.dart';
import 'package:sportal/screens/login.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/widgets/rectangle_button.dart';

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  final _fromKey = GlobalKey<FormState>();
  bool isCheckIn = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _fromKey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "Hi, User!",
                    //   style: AppTextTheme.headline24,
                    // ),

                    SizedBox(
                      height: 10.0.h,
                    ),

                    Image.asset(
                      "assets/images/logo.png",
                      height: 70.h,
                      fit: BoxFit.fitHeight,
                    ),
                    SizedBox(
                      height: 60.0.h,
                    ),

                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Hi, ",
                          style: AppTextTheme.bodyText18.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          )),
                      TextSpan(
                          text: user!.name!.split(' ')[0],
                          style: AppTextTheme.bodyText18.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ])),
                    SizedBox(
                      height: 8.0.h,
                    ),
                    Text(
                      "What would you like to do?",
                      style: AppTextTheme.bodyText16,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: RectangleButton(
                            isLoading: false,
                            text: "Enter".toUpperCase(),
                            textColor: Colors.white,
                            buttonColor: Colors.green,
                            onPressed: !isCheckIn
                                ? null
                                : () async {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => const Enter()),
                                    );
                                  },
                          ),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Expanded(
                          child: RectangleButton(
                            isLoading: false,
                            text: "Exit".toUpperCase(),
                            textColor: Colors.white,
                            buttonColor: Colors.orange,
                            onPressed: !isCheckIn
                                ? null
                                : () async {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => const Exit()),
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    RectangleButton(
                      isLoading: false,
                      text: "Activity Log Reports".toUpperCase(),
                      textColor: Colors.white,
                      buttonColor: primaryColor,
                      onPressed: !isCheckIn
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const ActivityLog()),
                              );
                            },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Log Out",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .logout();
                          },
                        style: AppTextTheme.bodyText20
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Check In',
                        style: AppTextTheme.bodyText20,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: Switch(
                            value: isCheckIn,
                            activeColor: isCheckIn ? primaryColor : Colors.red,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.red[200],
                            onChanged: (val) {
                              setState(() {
                                isCheckIn = val;
                              });
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
