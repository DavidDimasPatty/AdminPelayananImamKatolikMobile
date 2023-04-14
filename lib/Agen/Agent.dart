import 'dart:async';

import 'Message.dart';

abstract class Agent {
  bool canPerformTask(dynamic task);

  Future<dynamic> receiveMessage(Message msg, String sender);

  Future<dynamic> performTask();

  Message rejectTask(dynamic task, String sender);
  Message overTime(dynamic task, sender);
  action(String goals, dynamic data, String sender);
}
