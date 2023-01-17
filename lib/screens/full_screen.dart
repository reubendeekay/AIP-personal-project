// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sportal/models/user_model.dart';
import 'package:sportal/models/visitor_model.dart';
import 'package:sportal/providers/auth_provider.dart';
import 'package:sportal/providers/visitors_provider.dart';
import 'package:sportal/screens/log/message_screen.dart';
import 'package:sportal/widgets/rectangle_button.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({Key? key, required this.image, required this.visitor})
      : super(key: key);
  final File image;

  final VisitorModel visitor;

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  // final frontController = WidgetsToImageController();
  // final backController = WidgetsToImageController();
  bool isLoading = false;
  bool show = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () async {
      // final frontBytes = await frontController.capture();
      // final backBytes = await backController.capture();
      // widget.visitor.frontCnic = frontBytes;
      // widget.visitor.backCnic = backBytes;

      final id =
          await Provider.of<VisitorProvider>(context, listen: false).addVisitor(
        widget.visitor,
      );
      setState(() {
        isLoading = false;
      });
      if (id != null) {
        Get.to(() => MessageScreen(
              message: 'Visitor has been checked in successfully',
              visitor: id,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    // cnicImage(
                    //   size,
                    //   user,
                    //   widget.image,
                    //   frontController,
                    // ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RectangleButton(
                  text: 'ENTER',
                  isLoading: isLoading,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    // final frontBytes = await frontController.capture();
                    // final backBytes = await frontController.capture();
                    // widget.visitor.frontCnic = frontBytes;
                    // widget.visitor.backCnic = backBytes;
                    final id = await Provider.of<VisitorProvider>(context,
                            listen: false)
                        .addVisitor(
                      widget.visitor,
                    );
                    setState(() {
                      isLoading = false;
                    });
                    if (id != null) {
                      Get.to(() => MessageScreen(
                            message: 'Visitor has been checked in successfully',
                            visitor: id,
                          ));
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
          Container(
            color: Colors.grey[50],
            height: size.height,
            width: size.width,
            child: Center(
              child: Lottie.asset('assets/upload.json'),
            ),
          )
        ],
      )),
    );
  }

  WidgetsToImage cnicImage(Size size, UserModel? user, File image,
      WidgetsToImageController controller) {
    return WidgetsToImage(
      controller: controller,
      child: Stack(
        children: [
          Image.file(
            image,
            height: size.width * 0.9,
            width: size.width * 0.9,
          ),
          Positioned(
              bottom: 15,
              right: 15,
              left: 15,
              top: 15,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Date ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'En ${DateFormat('HH:mm').format(DateTime.now())}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'VISITOR',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      user!.company!,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
