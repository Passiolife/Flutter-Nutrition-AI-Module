import 'dart:async';
import 'dart:isolate';

class IsolateUtility<T, R> {
  late Isolate _isolate;
  late ReceivePort _receivePort;
  late SendPort _sendPort;
  Completer<R>? _completer;

  Future<void> init() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_entryPoint, _receivePort.sendPort);
    _sendPort = await _receivePort.first as SendPort;
  }

  static void _entryPoint<T, R>(SendPort sendPort) {
    ReceivePort isolateReceivePort = ReceivePort();
    sendPort.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((dynamic message) {
      final task = message[0] as Function(T);
      final replyTo = message[1] as SendPort;
      final input = message[2] as T;

      final result = task(input);
      replyTo.send(result);
    });
  }

  Future<R> sendReceive(Function(T) task, T message) {
    _completer = Completer<R>();
    _receivePort.listen((data) {
      _completer?.complete(data as R);
      dispose();  // Optionally dispose after first use
    });

    _sendPort.send([task, _receivePort.sendPort, message]);
    return _completer!.future;
  }

  void dispose() {
    _receivePort.close();
    _isolate.kill(priority: Isolate.immediate);
  }
}