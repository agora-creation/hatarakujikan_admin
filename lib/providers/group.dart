import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupProvider with ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList() {
    Stream<QuerySnapshot<Map<String, dynamic>>>? _ret;
    _ret = FirebaseFirestore.instance
        .collection('group')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return _ret;
  }
}
