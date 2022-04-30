import 'package:flutter/material.dart';
import 'package:hatarakujikan_admin/helpers/functions.dart';
import 'package:hatarakujikan_admin/helpers/style.dart';
import 'package:hatarakujikan_admin/models/admin.dart';
import 'package:hatarakujikan_admin/providers/admin.dart';
import 'package:hatarakujikan_admin/widgets/admin_header.dart';
import 'package:hatarakujikan_admin/widgets/custom_admin_scaffold.dart';
import 'package:hatarakujikan_admin/widgets/custom_text_button.dart';
import 'package:hatarakujikan_admin/widgets/custom_text_form_field2.dart';
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
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => EditNameDialog(
                        adminProvider: adminProvider,
                      ),
                    );
                  },
                ),
                TapListTile(
                  title: 'メールアドレス',
                  subtitle: admin?.email ?? '',
                  iconData: Icons.edit,
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => EditEmailDialog(
                        adminProvider: adminProvider,
                      ),
                    );
                  },
                ),
                TapListTile(
                  title: 'パスワード',
                  subtitle: '************************',
                  iconData: Icons.edit,
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => EditPasswordDialog(
                        adminProvider: adminProvider,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditNameDialog extends StatefulWidget {
  final AdminProvider adminProvider;

  EditNameDialog({required this.adminProvider});

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  TextEditingController name = TextEditingController();

  void _init() async {
    name.text = widget.adminProvider.admin?.name ?? '';
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
              label: '名前',
              controller: name,
              textInputType: null,
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
                  label: '保存する',
                  color: Colors.blue,
                  onPressed: () async {
                    if (!await widget.adminProvider.updateName(
                      id: widget.adminProvider.admin?.id,
                      name: name.text.trim(),
                    )) {
                      return;
                    }
                    widget.adminProvider.reloadAdmin();
                    customSnackBar(context, '管理者の名前を保存しました');
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

class EditEmailDialog extends StatefulWidget {
  final AdminProvider adminProvider;

  EditEmailDialog({required this.adminProvider});

  @override
  State<EditEmailDialog> createState() => _EditEmailDialogState();
}

class _EditEmailDialogState extends State<EditEmailDialog> {
  TextEditingController email = TextEditingController();

  void _init() async {
    email.text = widget.adminProvider.admin?.email ?? '';
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
                  label: '保存する',
                  color: Colors.blue,
                  onPressed: () async {
                    if (!await widget.adminProvider.updateEmail(
                      id: widget.adminProvider.admin?.id,
                      email: email.text.trim(),
                    )) {
                      return;
                    }
                    widget.adminProvider.reloadAdmin();
                    customSnackBar(context, '管理者のメールアドレスを保存しました');
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

class EditPasswordDialog extends StatefulWidget {
  final AdminProvider adminProvider;

  EditPasswordDialog({required this.adminProvider});

  @override
  State<EditPasswordDialog> createState() => _EditPasswordDialogState();
}

class _EditPasswordDialogState extends State<EditPasswordDialog> {
  TextEditingController password = TextEditingController();

  void _init() async {
    password.text = widget.adminProvider.admin?.password ?? '';
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
              label: 'パスワード',
              controller: password,
              textInputType: TextInputType.visiblePassword,
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
                  label: '保存する',
                  color: Colors.blue,
                  onPressed: () async {
                    if (!await widget.adminProvider.updatePassword(
                      id: widget.adminProvider.admin?.id,
                      password: password.text.trim(),
                    )) {
                      return;
                    }
                    widget.adminProvider.reloadAdmin();
                    customSnackBar(context, '管理者のパスワードを保存しました');
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
