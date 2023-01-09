import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:collection';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';


class fin extends StatelessWidget {

  final controller = TextEditingController();

  Future<void> launch(url) async {
    await launchUrl(scheme: 'https', host: url, path: 'headers/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Final"),

      ),
      body: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    launch(controller.text);
                  },
                  child: const Text('Go to URL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.text = "";
                  },
                  child: const Text('Erase URL'),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}