import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:hatarakujikan_admin/helpers/functions.dart';
import 'package:hatarakujikan_admin/helpers/side_menu.dart';
import 'package:hatarakujikan_admin/helpers/style.dart';
import 'package:hatarakujikan_admin/providers/admin.dart';
import 'package:hatarakujikan_admin/screens/login.dart';
import 'package:hatarakujikan_admin/widgets/custom_text_button.dart';

class CustomAdminScaffold extends StatelessWidget {
  final AdminProvider adminProvider;
  final String selectedRoute;
  final Widget? body;

  CustomAdminScaffold({
    required this.adminProvider,
    required this.selectedRoute,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'はたらくじかん for ADMIN',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => SignOutDialog(adminProvider: adminProvider),
              );
            },
          ),
        ],
      ),
      sideBar: SideBar(
        backgroundColor: Color(0xFFFFE0B2),
        iconColor: Colors.black54,
        textStyle: TextStyle(color: Colors.black54, fontSize: 14.0),
        activeBackgroundColor: Colors.white,
        activeIconColor: Colors.black54,
        activeTextStyle: TextStyle(color: Colors.black54, fontSize: 14.0),
        items: sideMenu(),
        selectedRoute: selectedRoute,
        onSelected: (item) {
          if (item.route != null) {
            Navigator.pushNamed(context, item.route!);
          }
        },
        footer: Container(
          height: 50.0,
          width: double.infinity,
          color: Color(0xFF616161),
          child: Center(
            child: Text(
              '© アゴラ・クリエーション',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              constraints: BoxConstraints(maxHeight: 850.0),
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}

class SignOutDialog extends StatelessWidget {
  final AdminProvider adminProvider;

  SignOutDialog({required this.adminProvider});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 450.0,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'ログアウトします。よろしいですか？',
              style: kDialogTextStyle,
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
                  label: 'はい',
                  color: Colors.blue,
                  onPressed: () async {
                    await adminProvider.signOut();
                    changeScreen(context, LoginScreen());
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
