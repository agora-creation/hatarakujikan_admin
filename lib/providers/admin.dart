import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hatarakujikan_admin/helpers/functions.dart';
import 'package:hatarakujikan_admin/models/admin.dart';
import 'package:hatarakujikan_admin/services/admin.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AdminProvider with ChangeNotifier {
  Status _status = Status.Uninitialized;
  FirebaseAuth? _auth;
  User? _fUser;
  AdminService _adminService = AdminService();
  AdminModel? _admin;

  Status get status => _status;
  User? get fUser => _fUser;
  AdminModel? get admin => _admin;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  AdminProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn() async {
    if (email.text == '') return false;
    if (password.text == '') return false;
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth!.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    await _auth!.signOut();
    _status = Status.Unauthenticated;
    await removePrefs('adminId');
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    email.text = '';
    password.text = '';
  }

  Future reloadAdmin() async {
    String? _adminId = await getPrefs('adminId');
    if (_adminId != null) {
      _admin = await _adminService.select(id: _adminId);
    }
    notifyListeners();
  }

  Future _onStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _fUser = firebaseUser;
      String? _adminId = await getPrefs('adminId');
      if (_adminId == null) {
        _status = Status.Unauthenticated;
        _admin = null;
      } else {
        _status = Status.Authenticated;
        _admin = await _adminService.select(id: _adminId);
      }
    }
    notifyListeners();
  }
}
