import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthem/widgets/user_widget.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: UserWidget(),
    )
  );
}