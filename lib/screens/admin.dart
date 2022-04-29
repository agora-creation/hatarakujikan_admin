import 'package:flutter/material.dart';
import 'package:hatarakujikan_admin/models/admin.dart';
import 'package:hatarakujikan_admin/providers/admin.dart';
import 'package:hatarakujikan_admin/widgets/admin_header.dart';
import 'package:hatarakujikan_admin/widgets/custom_admin_scaffold.dart';
import 'package:hatarakujikan_admin/widgets/tap_list_tile.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  static const String id = 'admin';

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    AdminModel? admin = adminProvider.admin;

    return CustomAdminScaffold(
      adminProvider: adminProvider,
      selectedRoute: id,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminHeader(
            title: '管理者の情報',
            message: '管理者の名前などを変更できます。',
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TapListTile(
                  title: '名前',
                  subtitle: admin?.name ?? '',
                  iconData: Icons.edit,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
