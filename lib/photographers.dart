import 'package:flutter/material.dart';

class PhotographersTab extends StatelessWidget {
  const PhotographersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Text('This is the Photographers tab'),
      ),
    );
  }
}
