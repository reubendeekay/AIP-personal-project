import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:sportal/models/visitor_model.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class VisitorProvider with ChangeNotifier {
  final twilioFlutter = TwilioFlutter(
    accountSid: 'AC2b7ed99ffaff1e6dfed2108bc1fc8b04',
    authToken: '04db1d93063c979a61de0927759bf0ca',
    twilioNumber: '+19706274702',
  );
  List<VisitorModel> _visitors = [];
  List<VisitorModel> get visitors => _visitors;
  Map<String, List<VisitorModel>> departmentsData = {};

  Future<List<VisitorModel>> getVisitors(List departs, String companyId,
      {DateTime? date}) async {
    final visitorData = await FirebaseFirestore.instance
        .collection('visitors')
        .where('company_id', isEqualTo: companyId)
        .get();

    final data =
        visitorData.docs.map((e) => VisitorModel.fromJson(e.data())).toList();
    _visitors = data;
    await getDepartmentalData(departs);

    notifyListeners();
    if (date != null) {
      final datedData = data
          .where((element) =>
              element.checkIn!.day == date.day &&
              element.checkIn!.month == date.month &&
              element.checkIn!.year == date.year)
          .toList();
      _visitors = datedData;
      return datedData;
    }

    return data;
  }

  Future<bool?> checkVisitorExists(VisitorModel visitor) async {
    final visit = await FirebaseFirestore.instance
        .collection('visitors')
        .where('cnic', isEqualTo: visitor.cnic)
        .get();
    if (visit.docs.isNotEmpty) {
      if (visit.docs.first.data()['check_out'] == null) {
        return true;
      } else {
        return null;
      }
    } else {
      return false;
    }
  }

  Future<VisitorModel?> addVisitor(
    VisitorModel visitor,
    //Uint8List imageBytes, Uint8List backImage
  ) async {
    final checkIfExists = await checkVisitorExists(visitor);
    if (checkIfExists == null) {
      await FirebaseFirestore.instance
          .collection('visitors')
          .doc(visitor.cnic)
          .update({
        'check_out': null,
        'check_in': DateTime.now().toIso8601String(),
      });
      final returnVistor = await FirebaseFirestore.instance
          .collection('visitors')
          .doc(visitor.cnic)
          .get();
      await twilioFlutter.sendSMS(
          toNumber: '+254796660187',
          messageBody:
              'Dear ${visitor.name}, you have been checked in at ${visitor.department} department at ${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())}. Have a lovely stay.');
      return VisitorModel.fromJson(returnVistor.data()!);
    } else if (checkIfExists) {
      Get.snackbar('Visitor Already Exists',
          'The visitor with CNIC ${visitor.cnic} already exists in the  department',
          backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);

      Get.back();
      return null;
    } else {
      // final upload = await FirebaseStorage.instance
      //     .ref('images/${visitor.cnic}.png')
      //     .putData(backImage);
      // final uploadFront = await FirebaseStorage.instance
      //     .ref('images/${visitor.cnic}front.png')
      //     .putData(imageBytes);

      // final imageUrl = await uploadFront.ref.getDownloadURL();
      // final backUrl = await upload.ref.getDownloadURL();

      visitor.frontCnic = '';
      visitor.backCnic = '';
      visitor.checkOut = null;

      await FirebaseFirestore.instance
          .collection('visitors')
          .doc(visitor.cnic)
          .set(visitor.toJson());

      final returnVistor = await FirebaseFirestore.instance
          .collection('visitors')
          .doc(visitor.cnic)
          .get();

      return VisitorModel.fromJson(returnVistor.data()!);
    }
  }

  Future<Map<String, List<VisitorModel>>> getDepartmentalData(
    List departments,
  ) async {
    Map<String, List<VisitorModel>> depts = {};
    for (final dept in departments) {
      List<VisitorModel> data = [];

      for (var element in _visitors) {
        if (element.departmentId == dept['id']) {
          data.add(element);
        }

        depts = {...depts, dept['name']: data};
      }
    }
    departmentsData = depts;
    notifyListeners();
    return depts;
  }

  Map<String, dynamic> getActivityData() {
    //In
    final inVisitors = _visitors;
    Map<String, dynamic> visitorsIn = {
      'data': inVisitors,
      'male': inVisitors
          .where((element) =>
              element.gender == 'male' || element.gender == 'gender.male')
          .length,
      'female': inVisitors
          .where((element) =>
              element.gender == 'female' || element.gender == 'gender.female')
          .length,
      'children': inVisitors.where((element) => element.hasChildren!).length,
      'vehicle': inVisitors.where((element) => element.hasVehicle!).length,
    };

    //Inside
    final insideVisitors =
        _visitors.where((element) => element.checkOut == null);
    Map<String, dynamic> visitorsInside = {
      'data': insideVisitors.toList(),
      'male': insideVisitors
          .where((element) =>
              element.gender == 'male' || element.gender == 'gender.male')
          .length,
      'female': insideVisitors
          .where((element) =>
              element.gender == 'female' || element.gender == 'gender.female')
          .length,
      'children':
          insideVisitors.where((element) => element.hasChildren!).length,
      'vehicle': insideVisitors.where((element) => element.hasVehicle!).length,
    };

//Out
    //Inside
    final outsideVisitors =
        _visitors.where((element) => element.checkOut != null);
    Map<String, dynamic> visitorsOut = {
      'data': outsideVisitors.toList(),
      'male': outsideVisitors
          .where((element) =>
              element.gender == 'male' || element.gender == 'gender.male')
          .length,
      'female': outsideVisitors
          .where((element) =>
              element.gender == 'female' || element.gender == 'gender.female')
          .length,
      'children':
          outsideVisitors.where((element) => element.hasChildren!).length,
      'vehicle': outsideVisitors.where((element) => element.hasVehicle!).length,
    };

    return {
      'in': visitorsIn,
      'inside': visitorsInside,
      'out': visitorsOut,
      'depts': departmentsData,
    };
  }

  Future<bool> checkOutVisitor(VisitorModel visitor) async {
    final exists = await checkVisitorExists(visitor);

    if (exists == null) {
      await FirebaseFirestore.instance
          .collection('visitors')
          .doc(visitor.cnic)
          .update({'check_out': DateTime.now().toIso8601String()});
      await twilioFlutter.sendSMS(
          toNumber: '+254796660187',
          messageBody:
              'Dear ${visitor.name}, you have been checked out at ${visitor.department} department at ${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())}. Thank you for visiting us.');
      return true;
    }
    if (exists) {
      await FirebaseFirestore.instance
          .collection('visitors')
          .doc(visitor.cnic)
          .update({'check_out': DateTime.now().toIso8601String()});
      await twilioFlutter.sendSMS(
          toNumber: '+254796660187',
          messageBody:
              'Dear ${visitor.name}, you have been checked out at ${visitor.department} department at ${DateFormat('dd/MM/yyyy hh:mm').format(DateTime.now())}. Thank you for visiting us.');
      return true;
    } else {
      return false;
    }
  }

  List<VisitorModel> filteredVisitors(
      List<VisitorModel> visits, Map<String, dynamic> query) {
    if (query.isEmpty) {
      return visits;
    }
    List<VisitorModel> newVisits = [];
//Filter by departments

    if (query['departments'].isNotEmpty) {
      if (query['departments'].contains('All')) {
        newVisits = visits;
      } else {
        for (var element in visits) {
          if (query['departments'].contains(element.department)) {
            newVisits.add(element);
          }
          if (query['departments'].contains('All')) {
            newVisits.add(element);
          }
        }
      }
    }

    if (query['departments'].isEmpty) {
      List<VisitorModel> newVisits1 = [];

      for (var element in visits) {
        if (query['gender'].contains(element.gender)) {
          newVisits1.add(element);
        }
        newVisits = newVisits1;
      }
    } else {
      if (query['gender'].isNotEmpty) {
        if (newVisits.isNotEmpty) {
          List<VisitorModel> newVisits1 = [];

          for (var element in newVisits) {
            if (query['gender'].contains(element.gender)) {
              newVisits1.add(element);
            }
          }
          newVisits = newVisits1;
        }
      }
    }

//Order by criteria in query
    if (query['sort'] != 'Relevance') {
      if (query['sort'] == 'CNIC') {
        newVisits.sort((a, b) => a.cnic!.compareTo(b.cnic!));
      } else if (query['sort'] == 'Phone number') {
        newVisits.sort((a, b) => a.phone!.compareTo(b.phone!));
      } else if (query['sort'] == 'Name') {
        newVisits.sort((a, b) => a.name!.compareTo(b.name!));
      } else if (query['sort'] == 'Department') {
        newVisits.sort((a, b) => a.department!.compareTo(b.department!));
      } else if (query['sort'] == 'Checkin') {
        newVisits.sort((a, b) => a.checkIn!.compareTo(b.checkIn!));
      }
    }

    return newVisits.toSet().toList();
  }

  Future<void> sendTestWhatsappMessage() async {
    final data = {
      // "channelId": 'b98966ab-3f58-4b20-8393-90ce8b5f8f38',
      // "to": '+254796660187',
      // "type": 'hsm',
      // "content": {
      //   "hsm": {
      //     "namespace": '03ee105d_e2a4_4260_b403_7ab5046f62d2',
      //     "templateName": 'check_in',
      //     "language": {
      //       "policy": 'deterministic',
      //       "code": 'en',
      //     },

      //     "params": [
      //       {"default": 'Transport'},
      //       {"default": 'Brick n Wall'},
      //       {"default": '17:15 hrs'},

      //     ]
      //   }
      // }

      "channelId": "b98966ab-3f58-4b20-8393-90ce8b5f8f38",
      "to": "+254796660187",
      "type": "hsm",
      "content": {
        "hsm": {
          "namespace": "03ee105d_e2a4_4260_b403_7ab5046f62d2",
          "templateName": "check_in",
          "language": {"policy": "deterministic", "code": "en"},
          "components": [
            {
              "type": "header",
              "parameters": [
                {
                  "type": "image",
                  "image": {
                    "url":
                        "https://www.brandsynario.com/wp-content/uploads/2017/11/CNIC.png"
                  }
                }
              ]
            },
            {
              "type": "body",
              "parameters": [
                {"type": "text", "text": "Transport"},
                {"type": "text", "text": "Brick n Wall"},
                {"type": "text", "text": "17:15 hrs"}
              ]
            }
          ]
        }
      }
    };

    await FirebaseFirestore.instance.collection('messages').add(data);
  }

  Future<void> uploadCheckInCard(String visitorId, Uint8List image) async {
    final ref =
        await FirebaseStorage.instance.ref('checkin/$visitorId').putData(image);
    final url = await ref.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('visitors')
        .doc(visitorId)
        .update({'visitorPass': url});

    notifyListeners();
  }
}
