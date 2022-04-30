import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:hatarakujikan_admin/helpers/functions.dart';
import 'package:hatarakujikan_admin/helpers/style.dart';
import 'package:hatarakujikan_admin/models/group.dart';
import 'package:hatarakujikan_admin/providers/admin.dart';
import 'package:hatarakujikan_admin/providers/group.dart';
import 'package:hatarakujikan_admin/widgets/admin_header.dart';
import 'package:hatarakujikan_admin/widgets/custom_admin_scaffold.dart';
import 'package:hatarakujikan_admin/widgets/custom_dropdown_button.dart';
import 'package:hatarakujikan_admin/widgets/custom_text_button.dart';
import 'package:hatarakujikan_admin/widgets/custom_text_form_field2.dart';
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
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => AddDialog(groupProvider: groupProvider),
                  );
                },
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
                    DataColumn2(label: Text('住所'), size: ColumnSize.M),
                    DataColumn2(label: Text('人数制限'), size: ColumnSize.S),
                    DataColumn2(label: Text('シフト表利用'), size: ColumnSize.M),
                    DataColumn2(label: Text('修正/削除'), size: ColumnSize.S),
                  ],
                  rows: List<DataRow>.generate(
                    groups.length,
                    (index) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${groups[index].name}')),
                          DataCell(Text('${groups[index].address}')),
                          DataCell(Text('${groups[index].usersNum}')),
                          DataCell(Text(groups[index].optionsShift == true
                              ? '有効'
                              : '無効')),
                          DataCell(IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) => EditDialog(
                                  groupProvider: groupProvider,
                                  group: groups[index],
                                ),
                              );
                            },
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

class AddDialog extends StatefulWidget {
  final GroupProvider groupProvider;

  AddDialog({required this.groupProvider});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              '情報を入力し、「登録する」ボタンをクリックしてください。',
              style: kDialogTextStyle,
            ),
            SizedBox(height: 16.0),
            CustomTextFormField2(
              label: '会社/組織名',
              controller: name,
              textInputType: null,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: '郵便番号',
              controller: zip,
              textInputType: null,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: '住所',
              controller: address,
              textInputType: TextInputType.streetAddress,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: '電話番号',
              controller: tel,
              textInputType: TextInputType.phone,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: 'メールアドレス',
              controller: email,
              textInputType: TextInputType.emailAddress,
              maxLines: 1,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextButton(
                  label: 'キャンセル',
                  color: Colors.grey,
                  onPressed: () => Navigator.pop(context),
                ),
                CustomTextButton(
                  label: '登録する',
                  color: Colors.blue,
                  onPressed: () async {
                    if (!await widget.groupProvider.create(
                      name: name.text.trim(),
                      zip: zip.text.trim(),
                      address: address.text.trim(),
                      tel: tel.text.trim(),
                      email: email.text.trim(),
                    )) {
                      return;
                    }
                    customSnackBar(context, '会社/組織を登録しました');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditDialog extends StatefulWidget {
  final GroupProvider groupProvider;
  final GroupModel group;

  EditDialog({
    required this.groupProvider,
    required this.group,
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  TextEditingController name = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController usersNum = TextEditingController();
  bool? optionsShift;

  void _init() async {
    name.text = widget.group.name;
    zip.text = widget.group.zip;
    address.text = widget.group.address;
    tel.text = widget.group.tel;
    email.text = widget.group.email;
    usersNum.text = widget.group.usersNum.toString();
    optionsShift = widget.group.optionsShift;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              '情報を変更し、「保存する」ボタンをクリックしてください。',
              style: kDialogTextStyle,
            ),
            SizedBox(height: 16.0),
            CustomTextFormField2(
              label: '会社/組織名',
              controller: name,
              textInputType: null,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: '郵便番号',
              controller: zip,
              textInputType: null,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: '住所',
              controller: address,
              textInputType: TextInputType.streetAddress,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: '電話番号',
              controller: tel,
              textInputType: TextInputType.phone,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: 'メールアドレス',
              controller: email,
              textInputType: TextInputType.emailAddress,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomTextFormField2(
              label: '人数制限',
              controller: usersNum,
              textInputType: TextInputType.number,
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            CustomDropdownButton(
              label: 'シフト表利用',
              isExpanded: true,
              value: optionsShift,
              onChanged: (value) {
                setState(() => optionsShift = value);
              },
              items: [
                DropdownMenuItem(
                  value: false,
                  child: Text(
                    '無効',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Text(
                    '有効',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextButton(
                  label: 'キャンセル',
                  color: Colors.grey,
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    CustomTextButton(
                      label: '削除する',
                      color: Colors.red,
                      onPressed: () async {
                        if (!await widget.groupProvider.delete(
                          id: widget.group.id,
                        )) {
                          return;
                        }
                        customSnackBar(context, '会社/組織を削除しました');
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 4.0),
                    CustomTextButton(
                      label: '保存する',
                      color: Colors.blue,
                      onPressed: () async {
                        if (!await widget.groupProvider.update(
                          id: widget.group.id,
                          name: name.text.trim(),
                          zip: zip.text.trim(),
                          address: address.text.trim(),
                          tel: tel.text.trim(),
                          email: email.text.trim(),
                          usersNum: int.parse(usersNum.text.trim()),
                          optionsShift: optionsShift,
                        )) {
                          return;
                        }
                        customSnackBar(context, '会社/組織を保存しました');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
