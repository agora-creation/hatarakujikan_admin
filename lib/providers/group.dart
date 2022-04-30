import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hatarakujikan_admin/services/group.dart';

class GroupProvider with ChangeNotifier {
  GroupService _groupService = GroupService();

  Future<bool> create({
    String? name,
    String? zip,
    String? address,
    String? tel,
    String? email,
  }) async {
    if (name == null) return false;
    try {
      String _id = _groupService.id();
      _groupService.create({
        'id': _id,
        'name': name,
        'zip': zip,
        'address': address,
        'tel': tel,
        'email': email,
        'userIds': [],
        'usersNum': 10,
        'adminUserId': '',
        'qrSecurity': false,
        'areaSecurity': false,
        'areaLat': 0,
        'areaLon': 0,
        'areaRange': 100,
        'roundStartType': '切捨',
        'roundStartNum': 1,
        'roundEndType': '切捨',
        'roundEndNum': 1,
        'roundBreakStartType': '切捨',
        'roundBreakStartNum': 1,
        'roundBreakEndType': '切捨',
        'roundBreakEndNum': 1,
        'roundWorkType': '切捨',
        'roundWorkNum': 1,
        'legal': 8,
        'nightStart': '22:00',
        'nightEnd': '05:00',
        'workStart': '09:00',
        'workEnd': '17:00',
        'holidays': ['土', '日'],
        'holidays2': [],
        'autoBreak': false,
        'optionsShift': false,
        'createdAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> update({
    String? id,
    String? name,
    String? zip,
    String? address,
    String? tel,
    String? email,
    int? usersNum,
    bool? optionsShift,
  }) async {
    if (id == null) return false;
    if (name == null) return false;
    try {
      _groupService.update({
        'id': id,
        'name': name,
        'zip': zip,
        'address': address,
        'tel': tel,
        'email': email,
        'usersNum': usersNum,
        'optionsShift': optionsShift,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> delete({String? id}) async {
    if (id == null) return false;
    try {
      _groupService.delete({'id': id});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList() {
    Stream<QuerySnapshot<Map<String, dynamic>>>? _ret;
    _ret = FirebaseFirestore.instance
        .collection('group')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return _ret;
  }
}
