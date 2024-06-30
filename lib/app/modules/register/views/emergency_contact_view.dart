import 'package:flutter/material.dart';

import 'package:get/get.dart';

class EmergencyContactView extends GetView {
  const EmergencyContactView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmergencyContactView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EmergencyContactView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
