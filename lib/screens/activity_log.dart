import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:sportal/models/visitor_model.dart';
import 'package:sportal/providers/auth_provider.dart';
import 'package:sportal/providers/visitors_provider.dart';
import 'package:sportal/screens/log/visitors_status.dart';
import 'package:sportal/util/app_text_theme.dart';
import 'package:sportal/util/color_constants.dart';
import 'package:sportal/util/extensions.dart';
import 'package:sportal/util/generate_pdf.dart';
import 'package:sportal/widgets/loading_shimmer.dart';
import 'package:sportal/widgets/rectangle_button.dart';

class ActivityLog extends StatefulWidget {
  const ActivityLog({Key? key}) : super(key: key);

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    final departments = user.departments!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Log"),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: Provider.of<VisitorProvider>(context, listen: false)
                .getVisitors(departments, user.companyId!,
                    date: selectedDateTime),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingEffect.getSearchLoadingScreen(context);
              }

              final data = Provider.of<VisitorProvider>(context, listen: false)
                  .getActivityData();
              final inData = data['in'];
              final outData = data['out'];
              final insideData = data['inside'];
              final depts = data['depts'] as Map<String, List<VisitorModel>>;
              return Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(16.0),
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDateTime == null
                                  ? 'All Activity'
                                  : "Activity of ${selectedDateTime!.toStandardDate()}",
                              style: AppTextTheme.bodyText18,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () async {
                              var dateTime = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2001, 1, 1),
                                lastDate: DateTime.now(),
                              );
                              if (dateTime != null) {
                                setState(() {
                                  selectedDateTime = dateTime;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => VisitorsStatus(
                                      visitorsIn: true,
                                      data: inData['data'],
                                    ));
                              },
                              child: ActivityLogCard(
                                title: "INN",
                                titleColor: Colors.green,
                                male: inData['male'],
                                female: inData['female'],
                                children: inData['children'],
                                vehicle: inData['vehicle'],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => VisitorsStatus(
                                      visitorsIn: false,
                                      data: outData['data'],
                                    ));
                              },
                              child: ActivityLogCard(
                                title: "OUT",
                                titleColor: Colors.red,
                                male: outData['male'],
                                female: outData['female'],
                                children: outData['children'],
                                vehicle: outData['vehicle'],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => VisitorsStatus(
                                      data: insideData['data'],
                                    ));
                              },
                              child: ActivityLogCard(
                                title: "INSIDE",
                                titleColor: Colors.orange,
                                male: insideData['male'],
                                female: insideData['female'],
                                children: insideData['children'],
                                vehicle: insideData['vehicle'],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text('Departments',
                          style: AppTextTheme.bodyText18
                              .copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(
                        height: 10.h,
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(
                          departments.length,
                          (index) => ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => VisitorsStatus(
                                      data: depts[departments[index]] == null
                                          ? []
                                          : depts[departments[index]]!,
                                    ));
                              },
                              child: ActivityLogCard(
                                title: departments[index]['name'],
                                titleColor: primaryColor,
                                male: depts[departments[index]] == null
                                    ? 0
                                    : depts[departments[index]]!
                                        .where((VisitorModel element) =>
                                            element.gender == ('gender.male') ||
                                            element.gender == ('male'))
                                        .length,
                                female: depts[departments[index]] == null
                                    ? 0
                                    : depts[departments[index]]!
                                        .where((VisitorModel element) =>
                                            element.gender ==
                                                ('gender.female') ||
                                            element.gender == ('female'))
                                        .length,
                                children: depts[departments[index]] == null
                                    ? 0
                                    : depts[departments[index]]!
                                        .where((VisitorModel element) =>
                                            element.hasChildren!)
                                        .length,
                                vehicle: depts[departments[index]] == null
                                    ? 0
                                    : depts[departments[index]]!
                                        .where((VisitorModel element) =>
                                            element.hasVehicle!)
                                        .length,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 15,
                    left: 15,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: RectangleButton(
                        isLoading: false,
                        text: "Download/Share".toUpperCase(),
                        textColor: Colors.white,
                        buttonColor: primaryColor,
                        onPressed: () async {
                          final visitors = Provider.of<VisitorProvider>(context,
                                  listen: false)
                              .visitors;
                          final pdfFile = await PdfInvoiceApi.generate(
                              List.generate(
                                  visitors.length, (index) => visitors[index]),
                              'Visitors Logs');

                          PdfApi.openFile(pdfFile);
                        },
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}

class ActivityLogCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final int male, female, children, vehicle;

  const ActivityLogCard({
    Key? key,
    required this.title,
    required this.male,
    required this.female,
    required this.children,
    required this.vehicle,
    required this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextTheme.headline18.copyWith(color: titleColor),
                  ),
                ),
                Text(
                  "${male + female}",
                  style: AppTextTheme.headline18,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Male",
                    style: AppTextTheme.bodyText14,
                  ),
                ),
                Text(
                  "$male",
                  style: AppTextTheme.bodyText14,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Female",
                    style: AppTextTheme.bodyText14,
                  ),
                ),
                Text(
                  "$female",
                  style: AppTextTheme.bodyText14,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Children",
                    style: AppTextTheme.bodyText14,
                  ),
                ),
                Text(
                  "$children",
                  style: AppTextTheme.bodyText14,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Vehicles",
                    style: AppTextTheme.bodyText14,
                  ),
                ),
                Text(
                  "$vehicle",
                  style: AppTextTheme.bodyText14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
