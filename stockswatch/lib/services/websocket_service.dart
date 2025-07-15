import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/stock.dart';

class WebSocketService {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.0.106:8080'),
  );

  Stream<List<Stock>> getStockStream() {
    return _channel.stream.map((data) {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((e) => Stock.fromJson(e)).toList();
    });
  }

  void dispose() {
    _channel.sink.close();
  }
}
