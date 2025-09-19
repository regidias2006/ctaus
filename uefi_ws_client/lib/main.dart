import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UEFI WS Client',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WebSocketPage(),
    );
  }
}

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  WebSocketPageState createState() => WebSocketPageState();
}

class WebSocketPageState extends State<WebSocketPage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.1.84:8080/ws'), // mesmo endpoint que o server
  );

  final _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('UEFI WebSocket Client')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _messages.add(snapshot.data.toString());
                  }
                  return ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) =>
                        ListTile(title: Text(_messages[index])),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Mensagem'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
