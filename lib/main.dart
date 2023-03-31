import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:universal_html/html.dart' as html;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.10.28:8080'),
  );

  final eventSource = html.EventSource('http://192.168.10.28:3030/events');

  @override
  Widget build(BuildContext context) {
    _channel.stream.listen((message) {
      // Handle the message here...
      SnackBar snackBar = SnackBar(
        content: Text('${message}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    eventSource.onMessage.listen((event) {
      // Handle the message here...
      SnackBar snackBar = SnackBar(
        content: Text('${event.data}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            // StreamBuilder(
            // stream: _channel.stream,
            // builder: (context, snapshot) {
            //   return Text(snapshot.hasData ? '${snapshot.data}' : '');
            // },
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
