import 'dart:async';

import 'Message.dart';
import 'Messages.dart';

abstract class Agent {
  bool canPerformTask(dynamic task);

  Future<dynamic> performTask(dynamic task, String sender);

  void rejectTask(dynamic task, String sender);
  Future<Message> action(String goals, dynamic data, String sender);
}
