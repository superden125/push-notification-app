import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: Center(child: Text('HELLO'))));
  }
}
