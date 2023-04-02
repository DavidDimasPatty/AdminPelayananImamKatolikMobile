import 'dart:async';

import 'Message.dart';

abstract class Agent {
  bool canPerformTask(dynamic task);

  Future<dynamic> performTask(Message msg, String sender);

  void rejectTask(dynamic task, String sender);
  Future<Message> action(String goals, dynamic data, String sender);
}
