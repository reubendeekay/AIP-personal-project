// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:sportal/models/visitor_model.dart';
import 'package:sportal/providers/visitors_provider.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/widgets/cnic_scan_button.dart';
import 'package:sportal/widgets/rectangle_button.dart';

class Exit extends StatefulWidget {
  const Exit({Key? key}) : super(key: key);

  @override
  State<Exit> createState() => _ExitState();
}

class _ExitState extends State<Exit> {
  final _formKey = GlobalKey<FormState>();

  bool carryChild = false;
  bool carryVehicle = false;

  final cnicTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exit from Department"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  CnicScanButton(
                    isExit: true,
                    cnicController: cnicTEController,
                    onCnicScanned: (cnic) async {
                      setState(() {
                        cnicTEController.text = cnic.identityNumber;
                      });

                      final visitor = VisitorModel(
                        cnic: cnic.identityNumber,
                      );
                      try {
                        final isDone = await Provider.of<VisitorProvider>(
                                context,
                                listen: false)
                            .checkOutVisitor(visitor);
                        if (isDone) {
                          Get.snackbar(
                            'Checked Out',
                            'Visitor checked out succesfully',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );

                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Visitor not found"),
                            ),
                          );

                          return;
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                        return;
                      }
                    },
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        primaryColor.withOpacity(0.5)
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RectangleButton(
                          isLoading: false,
                          text: "Confirm Exit".toUpperCase(),
                          textColor: Colors.white,
                          buttonColor: primaryColor,
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              final visitor = VisitorModel(
                                cnic: cnicTEController.text,
                              );

                              try {
                                final isDone =
                                    await Provider.of<VisitorProvider>(context,
                                            listen: false)
                                        .checkOutVisitor(visitor);
                                if (isDone) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: primaryColor,
                                      content: Text(
                                          "Visitor checked out successfully"),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Visitor not found"),
                                    ),
                                  );

                                  return;
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                                return;
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
