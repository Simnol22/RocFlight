import 'package:flutter/material.dart';

class FindView extends StatelessWidget {
  const FindView({super.key});

  static const routeName = '/find-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'This is the FindView',
            ),
          ],
        ),
      ),
    );
    ;
  }
}
