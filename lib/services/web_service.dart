import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class WebService {
  static final WebService _instance = WebService._internal();

  factory WebService() => _instance;

  WebService._internal();

  HttpServer? _server;

  final ValueNotifier<int> signalNotifier = ValueNotifier<int>(0); // Default to 0

  final String methodPost = 'POST';
  final String methodPut = 'PUT';
  final String methodGet = 'GET';

  final String routerSignal = '/api/signal';

  Future<void> startServer({int port = 8080}) async {
    if (_server != null) {
      debugPrint("Server already running.");
      return;
    }
    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      debugPrint("Local server started on port ${_server!.port}");
      _server!.listen((HttpRequest request) {
        _parseRequest(request);
      });
    } catch (e) {
      debugPrint("Error starting server: $e");
    }
  }

  void _parseRequest(HttpRequest request) async {
    String uri = request.uri.path;
    if (uri == routerSignal) {
      await _handlePostSignal(request);
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found')
        ..close();
    }
  }

  Future<void> _handlePostSignal(HttpRequest request) async {
    try {
      if (request.method != methodPost) {
        _responseMethodNotAllowed(request);
        return;
      }
      String content = await utf8.decodeStream(request);
      Map<String, dynamic> data = jsonDecode(content);

      if (data.containsKey('signal')) {
        int? signalValue = int.tryParse(data['signal'].toString());
        if (signalValue != null && signalValue >= 0 && signalValue <= 5) {
          signalNotifier.value = signalValue;
          request.response
            ..statusCode = HttpStatus.ok
            ..write('Signal updated to $signalValue')
            ..close();
        } else {
          _responseBadRequest(request, 'Invalid signal value. Must be an integer between 0 and 5.');
        }
      } else {
        _responseBadRequest(request, 'Missing "signal" key in request body.');
      }
    } catch (e) {
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('Error processing request: $e')
        ..close();
    }
  }

  void _responseMethodNotAllowed(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..write('Method Not Allowed')
      ..close();
  }

  void _responseBadRequest(HttpRequest request, String errorMessage) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write(errorMessage)
      ..close();
  }

  void stopServer() {
    _server?.close();
    _server = null;
    debugPrint("Local server stopped.");
  }
}
