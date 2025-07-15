import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/stock.dart';

List<Stock> parseStockData(String message) {
  final List<dynamic> jsonData = json.decode(message);
  return jsonData.map((item) => Stock.fromJson(item)).toList();
}

class WebSocketService {
  WebSocketChannel? _channel;

  StreamController<List<Stock>> _controller = StreamController.broadcast();

  Stream<List<Stock>> getStockStream() {
    if (_channel == null) {
      connect();  // 👈 Ensure connect is called when stream is first accessed
    }
    return _controller.stream;
  }

  void connect() {
    disconnect(); // Clean up before connecting

    _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.0.106:8080'));

    _channel!.stream.listen((message) {
      final List<Stock> stocks = parseStockData(message);
      _controller.add(stocks);
    }, onError: (error) {
      print('Socket error: $error');
    }, onDone: () {
      print('Socket closed');
    });
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void reconnect() {
    connect(); // Reconnect is just a clean connect
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}
