import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pretty_qr_code_plus/pretty_qr_code_plus.dart';
import 'package:provider/provider.dart';
import 'package:sportal/models/visitor_model.dart';
import 'package:sportal/providers/visitors_provider.dart';
import 'package:sportal/util/app_text_theme.dart';

import 'package:sportal/util/color_constants.dart';

import 'package:sportal/widgets/rectangle_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {Key? key, required this.message, this.onTap, required this.visitor})
      : super(key: key);
  final String message;
  final VisitorModel visitor;
  final Function? onTap;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final controller = WidgetsToImageController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetsToImage(
        controller: controller,
        child: Column(
          children: [
            const Spacer(),
            PrettyQrPlus(
              typeNumber: 6,
              size: 150.h,
              data:
                  'https://visitorsdash.tk/admin/visitors/${widget.visitor.cnic}',
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Generated Visitor QR Code',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.visitor.name!,
              style:
                  AppTextTheme.bodyText20.copyWith(fontWeight: FontWeight.bold),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RectangleButton(
                isLoading: isLoading,
                text: "Back".toUpperCase(),
                textColor: Colors.white,
                buttonColor: primaryColor,
                onPressed: () async {
                  if (widget.onTap == null) {
                    setState(() {
                      isLoading = true;
                    });
                    // final imageBytes = await controller.capture();

                    // await Provider.of<VisitorProvider>(context, listen: false)
                    //     .uploadCheckInCard(widget.visitor.cnic!, imageBytes!);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    widget.onTap!();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
