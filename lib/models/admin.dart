import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String _id = '';
  String _name = '';
  String _email = '';
  String _password = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  DateTime get createdAt => _createdAt;

  AdminModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    _id = snapshot.data()!['id'] ?? '';
    _name = snapshot.data()!['name'] ?? '';
    _email = snapshot.data()!['email'] ?? '';
    _password = snapshot.data()!['password'] ?? '';
    _createdAt = snapshot.data()!['createdAt'].toDate() ?? DateTime.now();
  }
}
