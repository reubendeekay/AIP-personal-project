import 'dart:io';

import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:sportal/models/cnic_model.dart';
import 'package:sportal/models/enums.dart';
import 'package:sportal/models/visitor_model.dart';
import 'package:sportal/providers/auth_provider.dart';
import 'package:sportal/providers/visitors_provider.dart';
import 'package:sportal/screens/full_screen.dart';

import 'package:sportal/services/cnic_scanner.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/widgets/cnic_scan_button.dart';
import 'package:sportal/widgets/kdropdown_button_form_field.dart';
import 'package:sportal/widgets/ktext_form_field.dart';
import 'package:sportal/widgets/rectangle_button.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Enter extends StatefulWidget {
  const Enter({Key? key}) : super(key: key);

  @override
  State<Enter> createState() => _EnterState();
}

class _EnterState extends State<Enter> {
  final _formKey = GlobalKey<FormState>();
  String? departmentId;

  bool isLoading = false;

  TextEditingController nameTEController = TextEditingController(),
      cnicTEController = TextEditingController(),
      phoneController = TextEditingController(),
      vehicleNumber = TextEditingController(),
      childrenNumber = TextEditingController();
  Gender? gender;
  String _phoneNumber = '';
  String mask = 'AAA-###';
  String mask2 = 'AA-####';
  bool carryChild = false;
  bool carryVehicle = false;
  bool hasCNIC = true;
  bool hasFront = false;
  bool userIn = false;

  XFile? cnicFrontFile;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter to Department"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Visit to:',
                style: AppTextTheme.bodyText16,
              ),
              const SizedBox(
                height: 8,
              ),
              KDropdownButtonFormField(
                labelText: "Department",
                hintText: "--select department--",
                items: user!.departments!
                    .map((e) => DropdownMenuItem(
                          value: e['id'],
                          child: Text(
                            e['name'],
                            style: AppTextTheme.bodyText16
                                .copyWith(color: primaryColor),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    departmentId = val as String?;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select department";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 18.h,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black.withOpacity(0.13)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xffeeeeee),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          _phoneNumber = number.phoneNumber!;
                        });
                        print(_phoneNumber);
                      },
                      onInputValidated: (bool value) {},
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      countries: const [
                        'KE',
                      ],
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      textFieldController: phoneController,
                      formatInput: false,
                      maxLength: 10,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      cursorColor: Colors.black,
                      inputDecoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(bottom: 15, left: 0),
                        border: InputBorder.none,
                        hintText: 'Mobile Number',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 16),
                      ),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                    Positioned(
                      left: 80,
                      top: 8,
                      bottom: 8,
                      child: Container(
                        height: 40,
                        width: 1,
                        color: Colors.black.withOpacity(0.13),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              CnicScanButton(
                isExit: false,
                nameController: nameTEController,
                cnicController: cnicTEController,
                onCnicScanned: (cnicModel) async {
                  nameTEController.text = cnicModel.holderName;
                  cnicTEController.text = cnicModel.identityNumber;
                  cnicFrontFile = cnicModel.file;
                  setState(() {
                    hasFront = true;
                  });
                  gender = cnicModel.gender;
                  final visitor = VisitorModel(
                    cnic: cnicTEController.text,
                  );
                  final exixts =
                      await Provider.of<VisitorProvider>(context, listen: false)
                          .checkVisitorExists(visitor);

                  if (exixts == true) {
                    setState(() {
                      isLoading = false;
                      userIn = true;
                    });
                    Get.snackbar(
                      "Visitor Inside",
                      "Visitor is still in the building",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              if (hasFront)
                RectangleButton(
                    text: 'Scan Back Side',
                    onPressed: () async {
                      CnicModel model = await CnicScanner()
                          .scanImage(imageSource: ImageSource.camera);

                      setState(() {
                        hasFront = model.file != null ? false : true;
                      });
                    }),
              if (!hasCNIC && cnicTEController.text.isEmpty)
                //CNIC Manual Input
                Column(children: [
                  SizedBox(
                    height: 18.h,
                  ),
                  Column(
                    children: [
                      KTextFormField(
                        labelText: 'Name',
                        hintText: 'Enter name',
                        controller: nameTEController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Please enter name";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 18.h),
                      KDropdownButtonFormField(
                        value: gender,
                        items: [
                          DropdownMenuItem<Gender>(
                            value: Gender.male,
                            child: Text(
                              "Male",
                              style: AppTextTheme.bodyText16
                                  .copyWith(color: primaryColor),
                            ),
                          ),
                          DropdownMenuItem<Gender>(
                            value: Gender.female,
                            child: Text(
                              "Female",
                              style: AppTextTheme.bodyText16
                                  .copyWith(color: primaryColor),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please select gender";
                          } else {
                            return null;
                          }
                        },
                        labelText: "Gender",
                        hintText: "--select gender--",
                      ),
                      SizedBox(height: 18.h),
                      KTextFormField(
                        labelText: 'CNIC Number',
                        maxLen: 15,
                        hintText: 'Enter CNIC number',
                        controller: cnicTEController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Please enter CNIC number";
                          } else if (value!.length < 12 || value.length > 15) {
                            return "Please enter valid CNIC number";
                          }
                          if (!value.contains('-')) {
                            return "CNIC should contain - for separation";
                          } else if (value.split('-').length < 3) {
                            return "CNIC should contain 2 - for separation";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ]),
              SizedBox(
                height: 18.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Child:",
                        style: AppTextTheme.bodyText18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    splashRadius: 0,
                                    value: true,
                                    onChanged: (value) {
                                      setState(() {
                                        carryChild = value as bool;
                                      });
                                    },
                                    groupValue: carryChild,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text(
                                    "Yes",
                                    style: AppTextTheme.bodyText16,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    splashRadius: 0,
                                    value: false,
                                    onChanged: (value) {
                                      setState(() {
                                        carryChild = value as bool;
                                      });
                                    },
                                    groupValue: carryChild,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text(
                                    "No",
                                    style: AppTextTheme.bodyText16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (carryChild)
                          KTextFormField(
                            hintText: "No. of children",
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter no. of children";
                              } else {
                                return null;
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 18.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Vehicle:",
                        style: AppTextTheme.bodyText18,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    splashRadius: 0,
                                    value: true,
                                    onChanged: (value) {
                                      setState(() {
                                        carryVehicle = value as bool;
                                      });
                                    },
                                    groupValue: carryVehicle,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text(
                                    "Yes",
                                    style: AppTextTheme.bodyText16,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    splashRadius: 0,
                                    value: false,
                                    onChanged: (value) {
                                      setState(() {
                                        carryVehicle = value as bool;
                                      });
                                    },
                                    groupValue: carryVehicle,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  Text(
                                    "No",
                                    style: AppTextTheme.bodyText16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (carryVehicle)
                          KTextFormField(
                            hintText: "Vehicle number",
                            inputFormatters: [
                              const UpperCaseTextFormatter(),
                              TextInputMask(mask: [
                                'AAA-999',
                                'AA-9999',
                              ])
                            ],
                            maxLen: 7,
                            controller: vehicleNumber,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter vehicle number";
                              } else {
                                return null;
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: RectangleButton(
                  // isLoading: isLoading,
                  text: userIn ? "ALREADY INSIDE" : "Enter".toUpperCase(),
                  textColor: Colors.white,
                  buttonColor: primaryColor,
                  onPressed: userIn
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              isLoading = true;
                            });

                            File? frontFile = cnicFrontFile == null
                                ? null
                                : File(cnicFrontFile!.path);

                            final visitor = VisitorModel(
                              cnic: cnicTEController.text,
                              departmentId: user.departments!.firstWhere(
                                  (element) =>
                                      element['id'] == departmentId)['id'],
                              department: user.departments!.firstWhere(
                                  (element) =>
                                      element['id'] == departmentId)['name'],
                              gender: gender.toString(),
                              company: user.company,
                              companyId: user.companyId,
                              checkIn: DateTime.now(),
                              checkOut: null,
                              hasChildren: carryChild,
                              hasVehicle: carryVehicle,
                              name: nameTEController.text,
                              phone: _phoneNumber,
                              frontCnic: frontFile,
                              backCnic: null,
                              children: childrenNumber.text.isEmpty
                                  ? null
                                  : int.parse(childrenNumber.text),
                              vehicleNumber: vehicleNumber.text.isEmpty
                                  ? null
                                  : vehicleNumber.text,
                            );
                            final exixts = await Provider.of<VisitorProvider>(
                                    context,
                                    listen: false)
                                .checkVisitorExists(visitor);

                            if (exixts == true) {
                              setState(() {
                                isLoading = false;
                              });
                              Get.snackbar(
                                "Visitor Inside",
                                "Visitor is still in the building",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                              );
                            } else {
                              Get.to(() => FullScreenImage(
                                    visitor: visitor,
                                    image: frontFile!,
                                  ));
                            }
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter implements TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}



    // StampImage.create(
    //                           context: context,
    //                           image: file,
    //                           children: [
    //                             Positioned(
    //                               bottom: 10,
    //                               right: 10,
    //                               child: Container(
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.black,
    //                                   border: Border.all(
    //                                       color: Colors.black, width: 2),
    //                                 ),
    //                                 child: Column(
    //                                   children: [
    //                                     Text(
    //                                       'Date ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
    //                                     ),
    //                                     Text(
    //                                       'En ${DateFormat('HH:mm').format(DateTime.now())}',
    //                                     ),
    //                                     const SizedBox(
    //                                       height: 15,
    //                                     ),
    //                                     const Center(
    //                                       child: Text(
    //                                         'VISITOR',
    //                                         style: TextStyle(fontSize: 24),
    //                                       ),
    //                                     ),
    //                                     const SizedBox(
    //                                       height: 15,
    //                                     ),
    //                                     const Center(
    //                                       child: Text(
    //                                         'MY HOME REAL ESTATE &\N BUILDERS',
    //                                         style: TextStyle(fontSize: 18),
    //                                       ),
    //                                     ),
    //                                     const SizedBox(
    //                                       height: 2,
    //                                     ),
    //                                     const Center(
    //                                       child: Text(
    //                                         'Baharia Town Karachi',
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                           onSuccess: (f) {
    //                             setState(() {
    //                               file = f;
    //                             });
    //                           },
    //                         );
