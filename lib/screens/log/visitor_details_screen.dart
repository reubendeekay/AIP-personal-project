import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code_plus/pretty_qr_code_plus.dart';

import 'package:sportal/models/visitor_model.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/util/constants.dart';
import 'package:sportal/util/generate_pdf.dart';
import 'package:sportal/widgets/rectangle_button.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:pdf/widgets.dart' as pw;

class VisitorDetailsScreen extends StatefulWidget {
  const VisitorDetailsScreen({Key? key, required this.visitor})
      : super(key: key);
  final VisitorModel visitor;

  @override
  State<VisitorDetailsScreen> createState() => _VisitorDetailsScreenState();
}

class _VisitorDetailsScreenState extends State<VisitorDetailsScreen> {
  final imageController = WidgetsToImageController();
  String calculateDuration() {
    if (widget.visitor.checkOut == null) {
      final difference = DateTime.now().difference(widget.visitor.checkIn!);
      if (difference.inDays > 0) {
        return '${difference.inDays} days';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes';
      } else {
        return '${difference.inSeconds} seconds';
      }
    }
    final difference =
        widget.visitor.checkOut!.difference(widget.visitor.checkIn!);
    if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes';
    } else {
      return '${difference.inSeconds} seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: WidgetsToImage(
                controller: imageController,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PrettyQrPlus(
                          typeNumber: 6,
                          size: 180.h,
                          data:
                              'https://visitorsdash.tk/admin/visitors/${widget.visitor.cnic}',
                          errorCorrectLevel: QrErrorCorrectLevel.H,
                          roundEdges: true,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Generated At: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          widget.visitor.name!,
                          style: AppTextTheme.bodyText20
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Phone: ${widget.visitor.phone}",
                          style: AppTextTheme.bodyText16,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "CNIC: ${widget.visitor.cnic}",
                          style: AppTextTheme.bodyText16,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const Text(
                          "Visiting to",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          widget.visitor.department!,
                          style: AppTextTheme.bodyText16,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          "Visitor Pass".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: "Check in: ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: DateFormat('dd/MM/yyyy HH:mm')
                                  .format(widget.visitor.checkIn!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ])),
                        SizedBox(
                          height: 10.h,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: "Check out: ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: widget.visitor.checkOut == null
                                  ? "Still inside"
                                  : DateFormat('dd/MM/yyyy HH:mm')
                                      .format(widget.visitor.checkOut!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                        ])),
                        if (widget.visitor.checkOut != null)
                          SizedBox(
                            height: 10.h,
                          ),
                        if (widget.visitor.checkOut != null)
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(
                                text: "Total time spent: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                )),
                            TextSpan(
                                text: calculateDuration(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                          ])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: RectangleButton(
                isLoading: false,
                text: "CALL".toUpperCase(),
                textColor: Colors.white,
                buttonColor: primaryColor,
                onPressed: () async {
                  const number = '254796660187';
                  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
                  if (res == true) {
                    print("success");
                  } else {
                    print("failed");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RectangleButton(
                isLoading: false,
                text: "PRINT ID".toUpperCase(),
                textColor: Colors.white,
                buttonColor: primaryColor,
                onPressed: () async {
                  final bytes = await imageController.capture();

                  final pdf = pw.Document();

                  final image = pw.MemoryImage(bytes!);

                  pdf.addPage(pw.Page(build: (pw.Context context) {
                    return pw.Center(
                      child: pw.Image(image),
                    ); // Center
                  }));
                  final file = await PdfApi.saveDocument(
                      name: 'Visitors Log.pdf', pdf: pdf);
                  await PdfApi.openFile(file);
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
