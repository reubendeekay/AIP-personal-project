import 'package:ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:sportal/providers/auth_provider.dart';
import 'package:sportal/screens/forgot_password.dart';
import 'package:sportal/screens/lobby.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/widgets/rectangle_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _fromKey = GlobalKey<FormState>();
  bool remember = true;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  bool isVisible = false;
  bool isLoading = false;
  late FocusNode passFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    passFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    passFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _fromKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 18.h,
                      ),
                      Image.asset(
                        "assets/images/logo.png",
                        height: 40.h,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 25.0.h,
                      ),
                      // Text(
                      //   "Welcome to",
                      //   style: AppTextTheme.headline20,
                      // ),
                      // Text(
                      //   "Sportal",
                      //   style: AppTextTheme.headline32.copyWith(color: primaryColor),
                      // ),

                      Text(
                        "Hello, ADMIN",
                        style: AppTextTheme.headline20,
                      ),
                      // SizedBox(
                      //   height: 5.h,
                      // ),
                      // Text(
                      //   "Login here",
                      //   style: AppTextTheme.bodyText18,
                      //   textAlign: TextAlign.center,
                      // ),
                      SizedBox(
                        height: 24.h,
                      ),
                      TextFormField(
                        style: AppTextTheme.bodyText18,
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          } else if (!value.contains('@') ||
                              !value.contains('.')) {
                            return "Please enter  valid email";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          constraints: const BoxConstraints(maxHeight: 70),
                          isDense: true,

                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 14, 12, 14),
                          labelText: "Email address",
                          hintText: "Enter Email address",
                          hintStyle: AppTextTheme.bodyText18,
                          // filled: true,
                          fillColor: primaryColor.withOpacity(0.2),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 2, color: Colors.red),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 2, color: Colors.red),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(width: 2, color: primaryColor),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(width: 2, color: primaryColor),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: passFocusNode,
                        child: TextFormField(
                          focusNode: passFocusNode,
                          style: AppTextTheme.bodyText18,
                          textInputAction: TextInputAction.done,
                          controller: passwordController,
                          obscureText: !isVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter password";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            constraints: const BoxConstraints(maxHeight: 70),
                            isDense: true,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              child: Icon(
                                !isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primaryColor,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 14, 12, 14),
                            labelText: "Password",
                            hintText: "Enter password",
                            hintStyle: AppTextTheme.bodyText18,
                            // filled: true,
                            fillColor: primaryColor.withOpacity(0.2),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.red),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.red),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide:
                                  BorderSide(width: 2, color: primaryColor),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide:
                                  BorderSide(width: 2, color: primaryColor),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Checkbox(
                            value: remember,
                            onChanged: (value) {
                              setState(() {
                                remember = value ?? false;
                              });
                            },
                          ),
                          Text(
                            "Remember Me",
                            softWrap: true,
                            style: AppTextTheme.bodyText14,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Forgot Password?",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => ForgotPassword());
                            },
                          style: AppTextTheme.bodyText14
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      RectangleButton(
                        isLoading: isLoading,
                        text: "Login".toUpperCase(),
                        textColor: Colors.white,
                        buttonColor: primaryColor,
                        onPressed: () async {
                          if (_fromKey.currentState?.validate() ?? false) {
                            setState(() {
                              isLoading = true;
                            });
                            final exists = await Provider.of<AuthProvider>(
                                    context,
                                    listen: false)
                                .login(
                              emailController.text,
                              passwordController.text,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            if (exists) {
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const Lobby()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text("Invalid Credentials"),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Center(child: Text('Powered by Sportal')))
            ],
          ),
        ),
      ),
    );
  }
}
