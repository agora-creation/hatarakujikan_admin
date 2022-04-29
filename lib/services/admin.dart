import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hatarakujikan_admin/models/admin.dart';

class AdminService {
  String _collection = 'admin';
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    _firebaseFirestore.collection(_collection).doc(values['id']).update(values);
  }

  Future<AdminModel?> select({String? id}) async {
    AdminModel? _admin;
    await _firebaseFirestore
        .collection(_collection)
        .doc(id)
        .get()
        .then((value) {
      _admin = AdminModel.fromSnapshot(value);
    });
    return _admin;
  }
}
