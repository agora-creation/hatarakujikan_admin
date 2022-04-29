import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:hatarakujikan_admin/screens/admin.dart';
import 'package:hatarakujikan_admin/screens/group.dart';

List<MenuItem> sideMenu() {
  List<MenuItem> ret = [
    MenuItem(
      title: '会社/組織の管理',
      route: GroupScreen.id,
      icon: Icons.store,
    ),
    MenuItem(
      title: '管理者の情報',
      route: AdminScreen.id,
      icon: Icons.settings,
    ),
  ];
  return ret;
}
