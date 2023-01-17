import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportal/models/cnic_model.dart';
import 'package:sportal/models/enums.dart';
import 'package:sportal/services/cnic_scanner.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/widgets/kdropdown_button_form_field.dart';
import 'package:sportal/widgets/ktext_form_field.dart';
import 'package:sportal/widgets/rectangle_button.dart';

class CnicScanButton extends StatefulWidget {
  const CnicScanButton(
      {super.key,
      this.isExit = false,
      this.onCnicScanned,
      this.cnicController,
      this.nameController});
  final bool isExit;
  final TextEditingController? nameController;
  final TextEditingController? cnicController;

  final Function(CnicModel)? onCnicScanned;

  @override
  State<CnicScanButton> createState() => _CnicScanButtonState();
}

class _CnicScanButtonState extends State<CnicScanButton> {
  TextEditingController nameTEController = TextEditingController(),
      cnicTEController = TextEditingController();
  // dobTEController = TextEditingController(),
  // doiTEController = TextEditingController(),
  // addressController = TextEditingController(),
  // doeTEController = TextEditingController();
  Gender? gender;
  CnicModel? _cnicModel;
  String? _errorText;
  XFile? file;
  int scanned = 0;

  Future<void> scanCnic(ImageSource imageSource) async {
    for (scanned; scanned < 1; scanned++) {
      try {
        CnicModel cnicModel =
            await CnicScanner().scanImage(imageSource: imageSource);
        if (cnicModel.identityNumber.isNotEmpty) {
          setState(() {
            _errorText = null;
            _cnicModel = cnicModel;
            nameTEController.text = cnicModel.holderName;
            cnicTEController.text = cnicModel.identityNumber;
            if (widget.nameController != null) {
              widget.nameController!.text = cnicModel.holderName;
            }
            // dobTEController.text = cnicModel.dateOfBirth;
            // doiTEController.text = cnicModel.issueDate;
            // doeTEController.text = cnicModel.expiryDate;
            // addressController.text = cnicModel.address;
            gender = cnicModel.gender;
            file = cnicModel.file;
            if (widget.cnicController != null) {
              widget.cnicController!.text = cnicTEController.text;
            }
            widget.onCnicScanned?.call(cnicModel);
          });
        } else {
          setState(() {
            _errorText = "Unable scan this document";
          });
        }
      } catch (e) {
        setState(() {
          _errorText = "Unable scan this document";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _cnicModel == null
        ? Column(
            children: [
              RectangleButton(
                text: "Scan CNIC".toUpperCase(),
                textColor: Colors.white,
                buttonColor: primaryColor,
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'CNIC Scanner',
                                style: AppTextTheme.headline20,
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                'Please select any option',
                                style: AppTextTheme.bodyText16,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 22.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RectangleButton(
                                    text: "Camera".toUpperCase(),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      scanCnic(ImageSource.camera);
                                    },
                                  ),
                                  RectangleButton(
                                    text: "GALLERY".toUpperCase(),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      scanCnic(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              if (_errorText != null)
                Column(
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      _errorText!,
                      style:
                          AppTextTheme.bodyText16.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            ],
          )
        : Column(
            children: [
              if (!widget.isExit)
                KTextFormField(
                  labelText: 'Name',
                  hintText: 'Enter name',
                  controller: widget.nameController ?? nameTEController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "Please enter name";
                    } else {
                      return null;
                    }
                  },
                ),
              if (!widget.isExit) SizedBox(height: 18.h),
              if (!widget.isExit)
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
                hintText: 'Enter CNIC number',
                controller: widget.cnicController ?? cnicTEController,
                maxLen: 15,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Please enter CNIC number";
                  } else if (value!.length < 12) {
                    return "Please enter valid CNIC number";
                  } else {
                    return null;
                  }
                },
              ),
              if (!widget.isExit) SizedBox(height: 18.h),
            ],
          );
  }
}
