import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:hatarakujikan_admin/models/group.dart';
import 'package:hatarakujikan_admin/providers/admin.dart';
import 'package:hatarakujikan_admin/providers/group.dart';
import 'package:hatarakujikan_admin/widgets/admin_header.dart';
import 'package:hatarakujikan_admin/widgets/custom_admin_scaffold.dart';
import 'package:hatarakujikan_admin/widgets/text_icon_button.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  static const String id = 'group';

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    List<GroupModel> groups = [];

    return CustomAdminScaffold(
      adminProvider: adminProvider,
      selectedRoute: id,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminHeader(
            title: '会社/組織の管理',
            message: '会社/組織の追加や、会社別のオプション追加などを設定できます。',
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              TextIconButton(
                iconData: Icons.add,
                iconColor: Colors.white,
                label: '新規登録',
                labelColor: Colors.white,
                backgroundColor: Colors.blue,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: groupProvider.streamList(),
              builder: (context, snapshot) {
                groups.clear();
                if (snapshot.hasData) {
                  for (DocumentSnapshot<Map<String, dynamic>> doc
                      in snapshot.data!.docs) {
                    groups.add(GroupModel.fromSnapshot(doc));
                  }
                }
                if (groups.length == 0) return Text('現在登録している会社/組織はありません。');
                return DataTable2(
                  columns: [
                    DataColumn2(label: Text('会社/組織名'), size: ColumnSize.M),
                    DataColumn2(label: Text('修正/削除'), size: ColumnSize.S),
                  ],
                  rows: List<DataRow>.generate(
                    groups.length,
                    (index) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${groups[index].name}')),
                          DataCell(IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {},
                          )),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
