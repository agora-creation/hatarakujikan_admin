import 'package:flutter/material.dart';
import 'package:hatarakujikan_admin/helpers/functions.dart';
import 'package:hatarakujikan_admin/helpers/style.dart';
import 'package:hatarakujikan_admin/providers/admin.dart';
import 'package:hatarakujikan_admin/screens/group.dart';
import 'package:hatarakujikan_admin/widgets/custom_text_form_field.dart';
import 'package:hatarakujikan_admin/widgets/error_dialog.dart';
import 'package:hatarakujikan_admin/widgets/loading.dart';
import 'package:hatarakujikan_admin/widgets/round_background_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: kLoginDecoration,
          child: adminProvider.status == Status.Authenticating
              ? Loading(color: Colors.white)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 150.0,
                        height: 150.0,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('はたらくじかん', style: kTitleTextStyle),
                        Text('for ADMIN', style: kSubTitleTextStyle),
                        SizedBox(height: 8.0),
                        Text(
                          '管理者のみ、メールアドレスとパスワードを入力してログインできます。',
                          style: kLoginTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      width: 350.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFormField(
                            controller: adminProvider.email,
                            obscureText: false,
                            textInputType: TextInputType.emailAddress,
                            maxLines: 1,
                            label: 'メールアドレス',
                            color: Colors.white,
                            prefix: Icons.email,
                            suffix: null,
                            onTap: null,
                          ),
                          SizedBox(height: 16.0),
                          CustomTextFormField(
                            controller: adminProvider.password,
                            obscureText: true,
                            textInputType: null,
                            maxLines: 1,
                            label: 'パスワード',
                            color: Colors.white,
                            prefix: Icons.lock,
                            suffix: null,
                            onTap: null,
                          ),
                          SizedBox(height: 24.0),
                          RoundBackgroundButton(
                            onPressed: () async {
                              if (!await adminProvider.signIn()) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => ErrorDialog(
                                    'ログインに失敗しました。メールアドレスまたはパスワードが間違っている可能性があります。',
                                  ),
                                );
                                return;
                              }
                              adminProvider.clearController();
                              changeScreen(context, GroupScreen());
                            },
                            label: 'ログイン',
                            color: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
