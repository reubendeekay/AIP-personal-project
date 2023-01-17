import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:sportal/models/user_model.dart';
import 'package:sportal/screens/login.dart';

class AuthProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  UserModel? _user;
  UserModel? get user => _user;

  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await getCurrentUser();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getCurrentUser({bool initial = false}) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userResults =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final departmentsResults = await FirebaseFirestore.instance
        .collection('companies')
        .doc(userResults['company_id'])
        .collection('departments')
        .get();

    final data = {
      ...userResults.data()!,
      'departments': departmentsResults.docs.map((e) => e.data()).toList(),
    };

    _user = UserModel.fromJson(data);
    notifyListeners();
    return _user;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.to(() => const Login());
  }
}
