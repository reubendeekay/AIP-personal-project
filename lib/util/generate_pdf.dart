import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:io';

import 'package:pdf/widgets.dart';
import 'package:sportal/models/visitor_model.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFilex.open(url);
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

class PdfInvoiceApi {
  static Future<File> generate(
      List<VisitorModel> visitors, String title) async {
    final pdf = Document();
    // final logo = await getImageFileFromAssets('assets/images/logo.png');
    //Change to bytes
    // final logoBytes = await logo.readAsBytes();

    pdf.addPage(MultiPage(
      margin: EdgeInsets.all(20),
      mainAxisAlignment: MainAxisAlignment.start,
      build: (context) => [
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(title),
        buildInvoice(visitors, title),
        Divider(),
      ],
      footer: (context) {
        return Row(children: [
          Text('Powered by'),
          SizedBox(width: 5),
          Text('Sportal')
          // Image(MemoryImage(logoBytes), width: 50),
        ]);
      },
    ));

    return PdfApi.saveDocument(name: '$title.pdf', pdf: pdf);
  }

  static Widget buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 120,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: DateTime.now().toString(),
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTitle(String title) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
              ),
            ],
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(List<VisitorModel> visitors, String title) {
    final headers = [
      'Name',
      'Phone number',
      'CNIC',
      'Department',
      'Gender',
      'Check in',
      if (!title.toLowerCase().contains("visitors inside")) 'Check out',
    ];
    final data = visitors.map((item) {
      return [
        item.name,
        item.phone,
        item.cnic,
        item.department,
        item.gender == 'male' ? 'Male' : 'Female',
        DateFormat('dd/MM/yyyy HH:mm').format(item.checkIn!),
        if (!title.toLowerCase().contains("visitors inside"))
          item.checkOut == null
              ? '-'
              : DateFormat('dd/MM/yyyy HH:mm').format(item.checkOut!),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellStyle: const TextStyle(fontSize: 9),
      tableWidth: TableWidth.max,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.center,
        5: Alignment.center,
        6: Alignment.center,
        7: Alignment.center,
      },
    );
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          Text('Powered by Visitors'),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
