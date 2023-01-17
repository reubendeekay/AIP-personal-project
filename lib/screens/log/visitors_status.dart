// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sportal/models/visitor_model.dart';
import 'package:sportal/providers/visitors_provider.dart';
import 'package:sportal/screens/log/filters.dart';
import 'package:sportal/screens/log/visitor_details_screen.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/generate_pdf.dart';

class VisitorsStatus extends StatefulWidget {
  const VisitorsStatus({Key? key, this.visitorsIn, required this.data})
      : super(key: key);
  final bool? visitorsIn;
  final List<VisitorModel> data;

  @override
  State<VisitorsStatus> createState() => _VisitorsStatusState();
}

class _VisitorsStatusState extends State<VisitorsStatus> {
  bool sort = false;
  Map<String, dynamic> filters = {};

  @override
  Widget build(BuildContext context) {
    final visitors = Provider.of<VisitorProvider>(context)
        .filteredVisitors(widget.data, filters);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return InkWell(
            onTap: () async {
              Scaffold.of(context).openEndDrawer();
            },
            child: const Icon(
              Icons.filter_alt_outlined,
            ),
          );
        }),
        title: Text(widget.visitorsIn == null
            ? 'Visitors Inside'
            : widget.visitorsIn!
                ? 'Visitors In'
                : 'Visitors Out'),
        actions: [
          InkWell(
            onTap: () async {
              final pdfFile = await PdfInvoiceApi.generate(
                  List.generate(visitors.length, (index) => visitors[index]),
                  '${widget.visitorsIn == null ? 'Visitors Inside' : widget.visitorsIn! ? 'Visitors In' : 'Visitors Out'} Logs');

              PdfApi.openFile(pdfFile);
            },
            child: const Icon(
              Icons.downloading_outlined,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
              onTap: () async {
                final pdfFile = await PdfInvoiceApi.generate(
                    List.generate(visitors.length, (index) => visitors[index]),
                    '${widget.visitorsIn == null ? 'Visitors Inside' : widget.visitorsIn! ? 'Visitors In' : 'Visitors Out'} Logs');

                final file = File(pdfFile.path);
                Share.shareFiles([file.path], text: 'Visitors Log');
              },
              child: const Icon(Icons.share)),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      endDrawer: Drawer(
        child: FiltersWidget(
          onFilter: (val) {
            setState(() {
              filters = val;
            });
          },
        ),
      ),
      body: visitors.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                      height: 140,
                      child: Transform.scale(
                          scale: 3,
                          child: Lottie.asset(
                            'assets/empty.json',
                            repeat: false,
                          ))),
                ),
                const Text('No visitor data')
              ],
            )
          : ListView.builder(
              itemCount: visitors.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        visitors[index].name!,
                        style: AppTextTheme.bodyText18,
                      ),
                      subtitle: Text(
                        'Phone: ${visitors[index].phone}\nDept: ${visitors[index].department}',
                        style: AppTextTheme.bodyText14,
                      ),
                      onTap: () {
                        Get.to(() => VisitorDetailsScreen(
                              visitor: visitors[index],
                            ));
                      },
                      trailing: Text(
                        visitors[index].cnic!,
                        style: AppTextTheme.bodyText14,
                      ),
                      dense: true,
                      isThreeLine: true,
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
    );
  }
}
