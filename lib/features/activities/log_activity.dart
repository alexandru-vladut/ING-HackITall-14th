// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ing_mobile/features/activities/recycle/recycle_activity.dart';
import 'package:ing_mobile/utilities/animation/slideright_toleft.dart';

class LogActivityPage extends StatefulWidget {
  const LogActivityPage({super.key});

  @override
  _LogActivityPageState createState() => _LogActivityPageState();
}

class _LogActivityPageState extends State<LogActivityPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log activity'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, SlideRightToLeft(page: const RecycleActivityPage()));
              },
              child: Text('Recycle'),
            ),
          ],
        ),
      ),
    );
  }
}
